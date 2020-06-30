extends EventNode


func _ready():
	show_close = true
	resizable = true
	set_slot(0, true, SLOT, in_color, false, SLOT, out_color)


func set_text(value : String) -> void:
	$TextEdit.text = value


func get_text() -> String:
	return $TextEdit.text


func to_dictionary() -> Dictionary:
	var d : Dictionary = .to_dictionary()
	d["node_type"] = "JumpNode"
	d["text"] = get_text()
	
	return d
