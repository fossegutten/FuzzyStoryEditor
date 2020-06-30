extends Control

signal checkpoint_updated(checkpoint)
signal story_started()
signal story_completed()

const EMPTY := -1


export(Resource) var current_story : Resource setget set_current_story

onready var text_helper : Node = $TextHelper
onready var expression_parser : Node = $ExpressionParser

func set_current_story(new_story : Resource) -> void:
	# we do this check since we cannot export custom resources to godot editor
	if new_story is FuzzyStory:
		current_story = new_story


func _ready():
	randomize()
	$DialogPlayer.connect("dialog_completed", self, "start_next_node")
	self.connect("story_completed", self, "hide")
	hide()
	
	expression_parser.parse('print("test")')
	expression_parser.parse("print('test')")
#	start("start", current_story)


func start(checkpoint : String = "start", story : FuzzyStory = null) -> void:
	
	if story:
		set_current_story(story)
	
	if !current_story:
		return
	
	var start : Dictionary = current_story.get_checkpoint_node(checkpoint)
	
	if start.size() == 0:
		printerr("Could not find checkpoint '%s'" % checkpoint)
		return
	
	process_story_node(start)
	show()
	
	emit_signal("story_started")



func process_story_node(node : Dictionary) -> void:
	
	var node_type : String = node["node_type"]
	
	if node_type == "CheckpointNode":
		
		emit_signal("checkpoint_updated", node["checkpoint"])
		start_next_node(node["next_id"])
		return
	
	elif node_type == "ConditionNode":
		
		# this is necessary to pull values from the registry
		var s : String = text_helper.inject_variables(node["text"])
		
		var result = expression_parser.parse(s)
		
		if result == true:
			start_next_node(node["next_id_true"])
			return
		elif result == false:
			start_next_node(node["next_id_false"])
			return
		else:
			print("Condition result was not a boolean: %s" % result)
			
	
	elif node_type == "DialogNode":
		
		# inject variables from our registry
		var dialog_text : String = text_helper.inject_variables(node.dialog)
		
		$DialogPlayer.start_dialog(node.character, node.mood, dialog_text, node.choices)
		return
	
	elif node_type == "FunctionCallNode":
		
		var target_string : String = node["class"]
		var function_string : String = node["function"]
		var params_string : String = node["params"]
		# converts the params string to Variant, will return a string if there are some mistakes in brackets etc.
		var params = str2var(params_string)
#		print("%s %s" % [typeof(params), params])
		# TODO add some error checking here
		
		
		var target : Object = null
		
		# empty target, assumes we try to target globalscope
		# not sure hof useful this is in a real game, but we can use print this way, for simple testing
		if target_string == "":
			var parse_string : String = function_string 
			parse_string += "('%s')" % str(params)
			
			expression_parser.parse(parse_string)
		
		# this is where we call functions on classes, if not targeting globalscope
		# there is probably a better way to do find a target class, like adding them to a registry, but this is intended to be a simple example
		elif target_string == "self":
			target = self
		elif target_string == "Registry":
			target = Registry
		else:
			printerr("Target does not exist: %s" % target_string)
		
		if target != null:
			print(function_string, " ", target.has_method(function_string))
			
			if target.has_method(function_string):
				if params.size() > 0:
					target.call(function_string, params)
				else:
					target.call(function_string)
		
#		print("%s %s %s %s" % [target, target_string, function_string, params])
		
		start_next_node(node["next_id"])
		return
	
	elif node_type == "JumpNode":
		# jump node has no output connections, so we grab the checkpoint node by string
		var target : Dictionary = current_story.get_checkpoint_node(node["text"])
		if target.size() > 0:
			process_story_node(target)
			return
	
	elif node_type == "RandomNode":
		var outcomes : Array = node["outcomes"]
		start_next_node( outcomes[randi() % outcomes.size()] )
		return
	
	# if we didnt return for some reason, complete the story
	emit_signal("story_completed")


func start_next_node(id : int) -> void:
	var next_node : Dictionary = current_story.get_story_node(id)
	if next_node.size() == 0:
		emit_signal("story_completed")
	else:
		process_story_node(next_node)



func _on_HideButton_pressed():
	hide()
