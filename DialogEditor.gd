extends Control

onready var graph_edit : GraphEdit = $VBox/HBox2/GraphEdit
onready var add_node_popup_menu : PopupMenu = $AddNodePopupMenu
onready var add_node_menu_button : MenuButton = $VBox/HBox2/VBox/AddNodeMenuButton

onready var dialog_node : PackedScene = preload("res://nodes/DialogNode.tscn")
onready var condition_node : PackedScene = preload("res://nodes/ConditionNode.tscn")

const POPUP_MENU_SIZE := Vector2(100, 100)
enum NodeType {
	DIALOG,
	CONDITION
}

var new_node_offset : Vector2 = Vector2()

func _ready():
	
	var p : PopupMenu = add_node_menu_button.get_popup()
	p.connect("id_pressed", self, "_on_AddNodeMenuButton_id_pressed")
	
	for i in [add_node_popup_menu, add_node_menu_button.get_popup()]:
		i.add_item("Dialog", NodeType.DIALOG)
		i.add_item("Condition", NodeType.CONDITION)
	
#	add_node_popup_menu.add_item("Dialog", NodeType.DIALOG)
#	add_node_popup_menu.add_item("Condition", NodeType.CONDITION)


#func _gui_input(event):
##func _unhandled_input(event):
#	if event is InputEventMouseButton:
#		if event.pressed and event.button_index == BUTTON_RIGHT:
#			add_node_popup_menu.popup_centered(Vector2(200, 200))


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
	for i in graph_edit.get_children():
		if i is EventNode:
			nodes.append(i)
	return nodes


func _on_AddNodeButton_pressed():
	pass
#	var new : EventNode = dialog_node.instance()
#	new.connect("close_request", self, "_on_EventNode_close_request", [new])
#	new.offset = get_event_nodes().size() * Vector2(60, 40)
#	graph_edit.add_child(new)
#	assign_node_id(new)
#
#	var node_name : String = "EventNode"
#	if "Dialog".is_subsequence_ofi(new.name):
#		node_name = "DialogNode"
#	elif "Condition".is_subsequence_ofi(new.name):
#		node_name = "ConditionNode"
#	else:
#		printerr("undefined event node type")
#
#	new.name = "%s%d" % [node_name, new.get_node_id()]
#	new.title = "%s - ID: %d" % [node_name, new.get_node_id()]


func _on_EventNode_close_request(requester : GraphNode) -> void:
	
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
		if i.from == from and i.from_port == from_slot:
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
	
#	add_node_popup_menu.popup(Rect2(release_position, POPUP_MENU_SIZE))


func _on_GraphEdit_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_RIGHT:
			for c in graph_edit.get_children():
				if c is GraphNode:
					if Rect2(c.rect_global_position, c.rect_size).has_point(get_global_mouse_position()):
#						print("%s: pos %s, size %s" % [c.name, c.rect_global_position, c.rect_size])
						return
			
			add_node_popup_menu.popup(Rect2(get_global_mouse_position(), POPUP_MENU_SIZE))
			new_node_offset = (get_global_mouse_position() + graph_edit.scroll_offset) / graph_edit.zoom - graph_edit.rect_global_position


func _on_AddNodeMenuButton_id_pressed(id):
	new_node_offset = (1 + get_event_nodes().size()) * Vector2(60, 40) + graph_edit.scroll_offset / graph_edit.zoom
	create_node(id)


func _on_AddNodePopupMenu_id_pressed(id):
	create_node(id)


func create_node(node_type : int):
	
	print([graph_edit.scroll_offset, graph_edit.rect_position, graph_edit.zoom, graph_edit.scroll_offset / graph_edit.zoom])
	
	var new_node : EventNode
	var node_name : String = "EventNode"
	
	match node_type:
		NodeType.DIALOG:
			new_node = dialog_node.instance()
			node_name = "DialogNode"
		NodeType.CONDITION:
			new_node = condition_node.instance()
			node_name = "ConditionNode"
		_:
			printerr("undefined event node type")
			return
	
	new_node.connect("close_request", self, "_on_EventNode_close_request", [new_node])
	new_node.offset = new_node_offset
	graph_edit.add_child(new_node)
	assign_node_id(new_node)
	
	new_node.name = "%s%d" % [node_name, new_node.get_node_id()]
	new_node.title = "%s - ID: %d" % [node_name, new_node.get_node_id()]
	
