extends EventNode


func _ready():
	set_slot(0, true, SLOT, in_color, true, SLOT, out_color)


func get_checkpoint_text() -> String:
	return $LineEdit.text

func set_checkpoint_text(value : String) -> void:
	$LineEdit.text = value
