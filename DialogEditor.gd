extends Control

onready var graph_edit : GraphEdit = $VBox/HBox2/GraphEdit


func assign_node_id(node : DWNode) -> void:
	
	var used_ids : Array = []
	for i in get_dw_nodes():
		used_ids.append(i.get_node_id())
	
	var new_id : int = 0
	while new_id in used_ids:
		new_id += 1
	
	node.set_node_id(new_id)
	print("New id %s for node %s" % [new_id, node])


func get_dw_nodes() -> Array:
	var nodes := []
	for i in graph_edit.get_children():
		if i is DWNode:
			nodes.append(i)
	return nodes

func _on_AddNodeButton_pressed():
	var new : DWNode = DWNode.new()
	new.connect("close_request", self, "_on_DWNode_close_request", [new])
	new.offset = get_dw_nodes().size() * Vector2(60, 40)
	graph_edit.add_child(new)
	assign_node_id(new)
	new.name = "Node %d" % [new.get_node_id()]
	new.title = "Node %d" % [new.get_node_id()]


func _on_DWNode_close_request(requester : GraphNode) -> void:
	requester.queue_free()
	pass
