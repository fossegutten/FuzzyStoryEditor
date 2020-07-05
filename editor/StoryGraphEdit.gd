extends GraphEdit
class_name EventEdit

signal right_clicked(position)

const NODE_OFFSET_STEP := Vector2(40, 40)
const POPUP_MENU_SIZE := Vector2(100, 100)
const AUTO := -1337

var new_node_offset : Vector2 = Vector2() setget set_new_node_offset

# input in global position
func set_new_node_offset(value : Vector2, from_global : bool = true) -> void:
	
	if from_global:
		value -= rect_global_position
	
	new_node_offset = (scroll_offset + value) / zoom
	
	# this caused all kinds of trouble
#	if use_snap:
#		new_node_offset = new_node_offset.snapped(Vector2.ONE * snap_distance)

func update_node_offset(from_global : bool) -> Vector2:
	var target_pos : Vector2 = NODE_OFFSET_STEP
	
	while(has_node_in_position(target_pos, from_global)):
		target_pos += NODE_OFFSET_STEP
	
	set_new_node_offset(target_pos, from_global)
	
	return target_pos


func has_node_in_position(position : Vector2, from_global : bool) -> bool:
#	if from_global:
	# TODO, if needed later
	for i in get_event_nodes():
		print(position, i.rect_position)
		if position.is_equal_approx(i.rect_position):
#		if min(position.x - i.rect_position.x, position.y - i.rect_position.y) <= snap_distance:
			return true
	return false


func _gui_input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_C and event.control:
				pass
			if event.scancode == KEY_D and event.control:
				for i in get_event_nodes():
					if i.selected:
						
						var d : Dictionary = i.to_dictionary()
						d["node_id"] = generate_free_node_id()
						d["metadata"]["position"] += update_node_offset(true)
#						d["metadata"]["position"] = i.offset + Vector2(20, 20)

						var n : EventNode = create_node_from_dictionary(d)
#
						
#						update_node_offset(false)
#						var n : EventNode = i.duplicate()
#						n.set_node_id(generate_free_node_id())
#						n.offset += update_node_offset(true)
#						add_child(n)
						
						n.selected = true
						i.selected = false
						
			if event.scancode == KEY_V and event.control:
				# copy
				print(event.control)
				pass
		pass
	
	if event is InputEventMouseButton:
		
		if event.pressed and event.button_index == BUTTON_RIGHT:
			for c in get_children():
				if c is GraphNode:
					var zoomed_rect := Rect2(c.rect_global_position, c.rect_size * zoom)
					if zoomed_rect.has_point(get_global_mouse_position()):
						return
			
			emit_signal("right_clicked", get_global_mouse_position())


func serialize_event_nodes() -> Array:
	var dictionaries := []
	
	for i in get_event_nodes():
		
		if i is EventNode:
			var d : Dictionary = i.to_dictionary()
			if d.node_type == "EventNode":
				printerr("EventNode type '%s' not implemented." % i.name)
			else:
				dictionaries.append(d)
		else:
			printerr("Not an EventNode: '%s'." % i)
	
	return dictionaries


func deserialize_event_nodes(story : FuzzyStory) -> void:
	
	var event_node_dicts : Array = story.get_story_nodes()
	
	# first add all nodes to the graph edit
	var dict_nodes : Array = []
	for i in event_node_dicts:
		var node : EventNode = create_node_from_dictionary(i)
		if node != null:
			dict_nodes.append(node)
	
	# then connect them all
	for i in event_node_dicts:
		
		var metadata : Dictionary = i["metadata"]
		var connections : Array = metadata["connections"]
		for j in connections:
			assert(j.from == metadata["node_name"])
			connect_node(j.from, j.from_port, j.to, j.to_port)


func is_node_id_free(id : int) -> bool:
	for i in get_event_nodes():
		if i.get_node_id() == id:
			return false
	return true


func generate_free_node_id() -> int:
	var used_ids : Array = []
	for i in get_event_nodes():
		used_ids.append(i.get_node_id())
	
	var new_id : int = 0
	while new_id in used_ids:
		new_id += 1
	
	return new_id


func get_event_nodes() -> Array:
	var nodes := []
	for i in get_children():
		if i is EventNode:
			nodes.append(i)
	return nodes


func clear_all_event_nodes() -> void:
	clear_connections()
	
	for i in get_event_nodes():
		remove_child(i)
		i.queue_free()





func create_node_from_enum(enum_value : int, node_id : int = AUTO) -> EventNode:
	# create the string, but this depends on enum being similar to node name string
	var type : String = EventNode.NodeType.keys()[enum_value].to_lower().capitalize().replacen(" ", "") + "Node"
	
	return create_node_from_string(type, node_id)


# creates, connects, childs, assigns id, renames and returns
func create_node_from_string(node_type : String, node_id : int = AUTO) -> EventNode:
	
	if not Global.NODE_SCENES.has(node_type):
		printerr("undefined event node type '%s', returning" % node_type)
		return null
	
	var node : EventNode = Global.NODE_SCENES[node_type].instance()
	
	node.connect("close_request", self, "_on_EventNode_close_request", [node])
	node.connect("resize_request", self, "_on_EventNode_resize_request", [node])
	
	add_child(node)
	
	if node_id == AUTO:
		node_id = generate_free_node_id()
	
	node.set_node_id(node_id)
	
	node.offset = new_node_offset
	
	node.name = "%s%d" % [node_type, node.get_node_id()]
	node.title = "%s - ID: %d" % [node_type, node.get_node_id()]
	
	return node


# restores everything except connections, including position and node specifics
func create_node_from_dictionary(d : Dictionary) -> EventNode:
	
	if not d.has("node_type"):
		printerr("Not valid dictionary '%s', returning" % d)
		return null
	
	var node_type : String = d["node_type"]
	
	var node : EventNode = create_node_from_string(node_type, d["node_id"])
	
	node.offset = d["metadata"]["position"]
	node.rect_size = d["metadata"]["size"]
	
	# Restore node specific data
	if node_type == "CheckpointNode":
		node.set_checkpoint_text(d["checkpoint"])
	
	elif node_type == "ConditionNode":
		node.set_text(d["text"])
	
	elif node_type == "DialogNode":
		node.set_character_text(d["character"])
		node.set_mood_text(d["mood"])
		node.set_dialog_text(d["dialog"])
		
		var choices : Array = d["choices"]
		node.update_slots(choices.size())
		
		for i in choices.size():
			var choice_line : LineEdit = node.get_choice_lines()[i]
			choice_line.text = choices[i]["text"]
	
	elif node_type == "FunctionCallNode":
		node.set_class_text(d["class"])
		node.set_function_text(d["function"])
		node.set_params_text(d["params"])
	
	elif node_type == "JumpNode":
		node.set_text(d["text"])
	
	elif node_type == "RandomNode":
		node.update_slots(d["outcomes"].size())
	
	else:
		printerr("Node type '%s' not implemented." % node_type)
	
	return node


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


func _on_StoryGraphEdit_connection_to_empty(from, from_slot, release_position):
	# disconnect the from slot
	for i in get_connection_list():
		if i.from == from and i.from_port == from_slot:
			disconnect_node(i.from, i.from_port, i.to, i.to_port)
	
	# TODO add a new node creation popup?


