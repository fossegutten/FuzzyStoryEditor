extends TextureButton


var template : Dictionary = {} setget set_template, get_template


func set_template(value : Dictionary) -> void:
	template = value
	update_visuals()


func get_template() -> Dictionary:
	return template


func update_visuals() -> void:
	if template.size() == 0:
		$Label.text = "Empty"
		self_modulate = Color.gray
	else:
		$Label.text = "Something"
		self_modulate = Color.green
		pass
