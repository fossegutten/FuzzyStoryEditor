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
