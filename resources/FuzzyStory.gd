extends Resource
class_name FuzzyStory

# array gets shared between instances if we initialize here, so we need to avoid that
export(Array) var story_nodes : Array #= []


func add_story_node(node : Dictionary) -> void:
	# just check a sample to make sure no random dictionary is passed in
	assert(node.has("node_id"))
	if node.has("node_id"):
		story_nodes.append(node)
	else:
		printerr("Story node: %s is not valid" % node)
