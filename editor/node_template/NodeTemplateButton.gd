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
		self_modulate = Color.darkgray
	else:
		var node_type : String = template["node_type"]
		
		$Label.text = node_type
		match node_type:
			"DialogNode":
				self_modulate = Color.aqua
			"CheckpointNode":
				self_modulate = Color.pink
			"ConditionNode":
				self_modulate = Color.orange
			"FunctionCallNode":
				self_modulate = Color.greenyellow
			"JumpNode":
				self_modulate = Color.orchid
			"RandomNode":
				self_modulate = Color.lightcoral
			_:
				self_modulate = Color.red
