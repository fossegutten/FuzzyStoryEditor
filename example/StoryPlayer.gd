extends Control

signal checkpoint_updated(checkpoint)
signal story_started()
signal story_completed()

const EMPTY := -1


export(Resource) var current_story : Resource setget set_current_story


func set_current_story(new_story : Resource) -> void:
	
	# we do this check since we cannot export custom resources to godot editor
	if new_story is FuzzyStory:
		current_story = new_story


func start(checkpoint : String = "start", story : FuzzyStory = null) -> void:
	
	if story:
		set_current_story(story)
	
	if !current_story:
		return
	
	var start : Dictionary = current_story.get_checkpoint_node(checkpoint)
	
	if start == {}:
		printerr("Could not find checkpoint '%s'" % start)
		return
	
	process_story_node(start)
	
	emit_signal("story_started")



func process_story_node(node : Dictionary) -> void:
	
	var next_id : int = EMPTY
	
	var node_type : String = node["node_type"]
	
	if node_type == "CheckpointNode":
		
		emit_signal("checkpoint_updated", node["checkpoint"])
		start_next_node(node["next_id"])
		return
	
	elif node_type == "ConditionNode":
		
		# TODO implement logic
		start_next_node(node["next_id"])
		return
	
	elif node_type == "DialogNode":
		pass
	
	elif node_type == "JumpNode":
		
		var target : Dictionary = current_story.get_checkpoint_node(node["text"])
		if target != {}:
			process_story_node(target)
			return
		
	
	elif node_type == "RandomNode":
		var choices : Array = node["choices"]
		
		start_next_node( randi() % choices.size() )
		return
	
	# if we didnt return for some reason, complete the story
	emit_signal("story_completed")


func start_next_node(id : int) -> void:
	var next_node : Dictionary = current_story.get_story_node(id)
	if next_node == {}:
		emit_signal("story_completed")
	else:
		process_story_node(next_node)

