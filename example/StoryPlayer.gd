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
		
		var s : String = text_helper.inject_variables(node["text"])
		
		var result = expression_parser.parse(s)
		
		# TODO implement logic, for now we just skip to next
		start_next_node(node["next_id"])
		return
	
	elif node_type == "DialogNode":
		
		# inject variables from our registry
		var dialog_text : String = text_helper.inject_variables(node.dialog)
		
		$DialogPlayer.start_dialog(node.character, node.mood, dialog_text, node.choices)
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
