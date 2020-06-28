extends Resource
class_name FuzzyStory

# array gets shared between instances if we initialize here, so we need to avoid that
export(Array) var story_nodes : Array setget ,get_story_nodes

#export(Array) var connection_list : Array #= []



func add_story_node(node : Dictionary) -> void:
	# just check a sample to make sure no random dictionary is passed in
	assert(node.has("node_id"))
	if node.has("node_id"):
		story_nodes.append(node)
	else:
		printerr("Story node: %s is not valid" % node)


func get_story_nodes() -> Array:
	return story_nodes


# helper functions
func get_story_node(id : int) -> Dictionary:
	
	var n : Dictionary
	
	for i in get_story_nodes():
		if i["node_id"] == id:
			n = i
	
	return n


func get_checkpoint_node(checkpoint : String) -> Dictionary:
	
	var n : Dictionary
	
	for i in get_story_nodes():
		if i["node_type"] == "CheckpointNode":
			if i["checkpoint"] == checkpoint:
				n = i
	
	return n
