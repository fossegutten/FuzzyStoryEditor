extends EventNode


# Not really implemented yet, might be changed

func _ready():
	show_close = true
	resizable = true
	set_slot(0, true, SLOT, in_color, false, SLOT, out_color)
	set_slot(1, false, SLOT, in_color, true, SLOT, out_color)
	set_slot(2, false, SLOT, in_color, true, SLOT, out_color)


func set_text(value : String) -> void:
	$TextEdit.text = value


func get_text() -> String:
	return $TextEdit.text


func to_dictionary() -> Dictionary:
	var d : Dictionary = .to_dictionary()
	d["node_type"] = "ConditionNode"
	d["text"] = get_text()
	d["next_id_true"] = EMPTY_NODE_ID
	d["next_id_false"] = EMPTY_NODE_ID
	
	for c in d["metadata"]["connections"]:
		# it skips the port 0 if it's not open, and turns port 1 into 0, and so on
		var target : EventNode = get_parent().get_node(c.to)
		if c.from_port == 0:
			d["next_id_true"] = target.get_node_id()
		elif c.from_port == 1:
			d["next_id_false"] = target.get_node_id()
	
	return d
