extends EventNode


func _ready():
	set_slot(0, true, SLOT, in_color, true, SLOT, out_color)


func get_class_text() -> String:
	return $HBoxClass/LineEdit.text


func set_class_text(value : String) -> void:
	$HBoxClass/LineEdit.text = value


func get_function_text() -> String:
	return $HBoxFunction/LineEdit.text


func set_function_text(value : String) -> void:
	$HBoxFunction/LineEdit.text = value


func get_params_text() -> String:
	return $HBoxParams/LineEdit.text


func set_params_text(value : String) -> void:
	$HBoxParams/LineEdit.text = value


func to_dictionary() -> Dictionary:
	var d : Dictionary = .to_dictionary()
	d["node_type"] = "FunctionCallNode"
	d["class"] = get_class_text()
	d["function"] = get_function_text()
	# just store the params as a string, for simplicity
	d["params"] = get_params_text()
	
	d["next_id"] = EMPTY_NODE_ID
	
	for c in d["metadata"]["connections"]:
		var target : EventNode = get_parent().get_node(c.to)
		d["next_id"] = target.get_node_id()
	
	return d
