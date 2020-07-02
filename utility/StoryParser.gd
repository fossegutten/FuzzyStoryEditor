extends Node

const EMPTY := -1

#onready var graph_edit : GraphEdit = $"../VBox/HBox2/StoryGraphEdit"


func array_to_graph(graph_edit : GraphEdit, story : FuzzyStory) -> bool:
	
	var event_node_dicts : Array = story.get_story_nodes()
	
	# first add all nodes to the graph edit
	var dict_nodes : Array = []
	for i in event_node_dicts:
		var node : EventNode = graph_edit.create_node_from_dictionary(i)
#		var node : EventNode = create_node_from_dictionary(graph_edit, i)
		if node != null:
			dict_nodes.append(node)
	
	# then connect them all
	for i in event_node_dicts:
		
		var metadata : Dictionary = i["metadata"]
		var connections : Array = metadata["connections"]
		for j in connections:
#			print([j.from, metadata["node_name"]])
#			print([j.from == metadata["node_name"]])
			assert(j.from == metadata["node_name"])
			graph_edit.connect_node(j.from, j.from_port, j.to, j.to_port)
			
#		print(connections)
#		pass
	
	return false


# TODO add checks for everything here
func create_node_from_dictionary(graph_edit : GraphEdit, dict : Dictionary) -> EventNode:
	
	# Assumes we have all the other data, if we have the node_type
	if !dict.has("node_type"):
		printerr("Node not created. Not valid dictionary: %s" % dict)
		return null
	
	# assume the dictionary is valid, if we get to here
	
	var node : EventNode = null
	
	# common data for all nodes
	var node_type : String = dict["node_type"]
	var node_id : int = dict["node_id"]
	var metadata : Dictionary = dict["metadata"]
	
	node = graph_edit.create_node_from_string(node_type, node_id)
	
	# node name should not be needed for anything, but connections might be useful to store in metadata
	node.offset = metadata["position"]
	node.rect_size = metadata["size"]
	
	# node specific variables
	if node_type == "CheckpointNode":
		node.set_checkpoint_text(dict["checkpoint"])
	elif node_type == "ConditionNode":
		node.set_text(dict["text"])
	elif node_type == "DialogNode":
		node.set_character_text(dict["character"])
		node.set_mood_text(dict["mood"])
		node.set_dialog_text(dict["dialog"])
		
		var choices : Array = dict["choices"]
		
		node.update_slots(choices.size())
		
		for i in choices.size():
			var choice_line : LineEdit = node.get_choice_lines()[i]
			choice_line.text = choices[i]["text"]
	
	elif node_type == "FunctionCallNode":
		node.set_class_text(dict["class"])
		node.set_function_text(dict["function"])
		node.set_params_text(dict["params"])
		
#		var params : Array = dict["params"]
#		if params.size() > 0:
#			# convert array into string
#			node.set_params_text(str(params))
	elif node_type == "JumpNode":
		node.set_text(dict["text"])
	elif node_type == "RandomNode":
		node.update_slots(dict["outcomes"].size())
	else:
		printerr("Node type '%s' not implemented." % node_type)
	
	return node


func graph_to_array(graph_edit : GraphEdit, event_nodes : Array) -> Array:
	var dictionaries := []
	
	for i in event_nodes:
		
		if i is EventNode:
			var d : Dictionary = i.to_dictionary()
			if d.node_type == "EventNode":
				printerr("EventNode type '%s' not implemented." % i.name)
			else:
				dictionaries.append(d)
		else:
			printerr("Not an EventNode: '%s'." % i)
	
	
	return dictionaries
