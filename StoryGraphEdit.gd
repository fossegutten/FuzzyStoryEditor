extends GraphEdit
class_name EventEdit

signal right_clicked(position)

onready var dialog_node : PackedScene = preload("res://nodes/DialogNode.tscn")
onready var condition_node : PackedScene = preload("res://nodes/ConditionNode.tscn")
onready var checkpoint_node : PackedScene = preload("res://nodes/CheckpointNode.tscn")
onready var function_call_node : PackedScene = preload("res://nodes/FunctionCallNode.tscn")
onready var random_node : PackedScene = preload("res://nodes/RandomNode.tscn")

const POPUP_MENU_SIZE := Vector2(100, 100)

var new_node_offset : Vector2 = Vector2() setget set_new_node_offset

# input in global position
func set_new_node_offset(value : Vector2, from_global : bool = true) -> void:
	
	if from_global:
		value -= rect_global_position
	
	new_node_offset = (scroll_offset + value) / zoom
	
	# this caused all kinds of trouble
#	if use_snap:
#		new_node_offset = new_node_offset.snapped(Vector2.ONE * snap_distance)


func assign_node_id(node : EventNode) -> void:
	
	var used_ids : Array = []
	for i in get_event_nodes():
		used_ids.append(i.get_node_id())
	
	var new_id : int = 0
	while new_id in used_ids:
		new_id += 1
	
	node.set_node_id(new_id)
#	print("New id %s for node %s" % [new_id, node])


func get_event_nodes() -> Array:
	var nodes := []
	for i in get_children():
		if i is EventNode:
			nodes.append(i)
	return nodes


func has_node_in_position(position : Vector2, from_global : bool) -> bool:
#	if from_global:
	# TODO, if needed later
	
	for i in get_event_nodes():
		if position.is_equal_approx(i.rect_position):
#		if min(position.x - i.rect_position.x, position.y - i.rect_position.y) <= snap_distance:
			return true
	return false


func create_node(node_type : int):
	
	var new_node : EventNode
	var node_name : String = "EventNode"
	
	match node_type:
		EventNode.NodeType.DIALOG:
			new_node = dialog_node.instance()
			node_name = "DialogNode"
		EventNode.NodeType.CHECKPOINT:
			new_node = checkpoint_node.instance()
			node_name = "CheckpointNode"
		EventNode.NodeType.CONDITION:
			new_node = condition_node.instance()
			node_name = "ConditionNode"
		EventNode.NodeType.FUNCTION_CALL:
			new_node = function_call_node.instance()
			node_name = "FunctionCallNode"
		EventNode.NodeType.RANDOM:
			new_node = random_node.instance()
			node_name = "RandomNode"
		_:
			printerr("undefined event node type")
			return
	
	new_node.connect("close_request", self, "_on_EventNode_close_request", [new_node])
	new_node.connect("resize_request", self, "_on_EventNode_resize_request", [new_node])
	
	add_child(new_node)
	assign_node_id(new_node)
	
	new_node.offset = new_node_offset
#	new_node.rect_position = new_node_offset
	
	new_node.name = "%s%d" % [node_name, new_node.get_node_id()]
	new_node.title = "%s - ID: %d" % [node_name, new_node.get_node_id()]


func _on_EventNode_resize_request(size : Vector2, requester : GraphNode) -> void:
	if use_snap:
		size = size.snapped(Vector2.ONE * snap_distance)
	requester.rect_size = size


func _on_EventNode_close_request(requester : GraphNode) -> void:
	# remove all connections for this node
	for i in get_connection_list():
		if i.from == requester.name or i.to == requester.name:
			disconnect_node(i.from, i.from_port, i.to, i.to_port)
	
	requester.queue_free()


func _on_StoryGraphEdit_connection_request(from, from_slot, to, to_slot):
	# we cant connect to ourselves
	if from == to:
		return
	
	# max one output connection, so disconnect the old ones
	for i in get_connection_list():
		if i.from == from and i.from_port == from_slot:
			disconnect_node(i.from, i.from_port, i.to, i.to_port)
	
#	print(from, from_slot, to, to_slot)
	var err := connect_node(from, from_slot, to, to_slot)
	if err != OK:
		printerr("Error connecting node: %s" % err)


#func _on_GraphEdit_connection_from_empty(to, to_slot, release_position):
	# TODO add a new node creation popup?


func _on_StoryGraphEdit_connection_to_empty(from, from_slot, release_position):
	# disconnect the from slot
	for i in get_connection_list():
		if i.from == from and i.from_port == from_slot:
			disconnect_node(i.from, i.from_port, i.to, i.to_port)
	
	# TODO add a new node creation popup?

func _gui_input(event):
#func _on_GraphEdit_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_RIGHT:
			for c in get_children():
				if c is GraphNode:
					var zoomed_rect := Rect2(c.rect_global_position, c.rect_size * zoom)
					if zoomed_rect.has_point(get_global_mouse_position()):
						return
			
			emit_signal("right_clicked", get_global_mouse_position())
#			add_node_popup_menu.popup(Rect2(get_global_mouse_position(), POPUP_MENU_SIZE))
#			new_node_offset = (get_global_mouse_position() + scroll_offset) / zoom - rect_global_position
