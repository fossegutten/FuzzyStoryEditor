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
