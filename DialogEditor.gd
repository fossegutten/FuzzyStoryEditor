extends Control

onready var graph_edit : GraphEdit = $VBox/HBox2/GraphEdit

onready var dw_node : PackedScene = preload("res://nodes/DWNode.tscn")

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
	var new : DWNode = dw_node.instance()
	new.connect("close_request", self, "_on_DWNode_close_request", [new])
	new.offset = get_dw_nodes().size() * Vector2(60, 40)
	graph_edit.add_child(new)
	assign_node_id(new)
	new.name = "Node name %d" % [new.get_node_id()]
	new.title = "Node title %d" % [new.get_node_id()]


func _on_DWNode_close_request(requester : GraphNode) -> void:
	
	# remove all connections
	for i in graph_edit.get_connection_list():
		if i.from == requester.name or i.to == requester.name:
			graph_edit.disconnect_node(i.from, i.from_port, i.to, i.to_port)
	
	requester.queue_free()


func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	if from == to:
		return
	
	# max one target connection
	for i in graph_edit.get_connection_list():
		if i.from == from:
			graph_edit.disconnect_node(i.from, i.from_port, i.to, i.to_port)
	
	print(from, from_slot, to, to_slot)
	var err := graph_edit.connect_node(from, from_slot, to, to_slot)
	if err != OK:
		printerr("Error connecting node: %s" % err)


#func _on_GraphEdit_connection_from_empty(to, to_slot, release_position):
#	for i in graph_edit.get_connection_list():
#		if i.to == to and i.to_port == to_slot:
#			graph_edit.disconnect_node(i.from, i.from_port, i.to, i.to_port)


func _on_GraphEdit_connection_to_empty(from, from_slot, release_position):
	for i in graph_edit.get_connection_list():
		if i.from == from and i.from_port == from_slot:
			graph_edit.disconnect_node(i.from, i.from_port, i.to, i.to_port)
