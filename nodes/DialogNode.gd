extends EventNode
#class_name DialogNode


onready var choice_line : PackedScene = preload("res://nodes/controls/DialogChoiceLine.tscn")
onready var choice_spin_box : SpinBox = $ChoicesHBox/ChoicesSpinBox

const CHOICE_SLOT_START := 4

func _ready():
	show_close = true
	resizable = true
	set_slot(0, true, SLOT, in_color, false, SLOT, out_color)
	update_slots(choice_spin_box.value)


func get_dialog_text() -> String:
	return $DialogTextEdit.text


func set_dialog_text(value : String) -> void:
	$DialogTextEdit.text = value


func get_character_text() -> String:
	return $NameMoodHBox/CharacterLineEdit.text


func set_character_text(value : String) -> void:
	$NameMoodHBox/CharacterLineEdit.text = value


func get_mood_text() -> String:
	return $NameMoodHBox/MoodLineEdit.text


func set_mood_text(value : String) -> void:
	$NameMoodHBox/MoodLineEdit.text = value


#func get_choices() -> Array:
#	var choices : Array
#
#	for i in get_choice_lines():
#		choices.append()
#
#	return choices


func get_choice_lines() -> Array:
	var choice_lines : Array = []
	for i in get_children():
		if i.is_in_group("choice_line"):
			choice_lines.append(i)
	return choice_lines


func update_slots(choices : int) -> void:
	assert(choices > 0)
	
	# if we update from save system, also update the spinbox
	if $ChoicesHBox/ChoicesSpinBox.value != choices:
		$ChoicesHBox/ChoicesSpinBox.value = choices
	
	var choice_lines : Array = get_choice_lines()
	
	for i in choice_lines.size():
		if i > choices - 1:
			var c : Control = choice_lines[choice_lines.size() - 1]
			choice_lines.remove(choice_lines.size() - 1)
			c.connect("tree_exited", self, "_on_child_tree_exited")
			c.queue_free()
	
	for i in choice_spin_box.max_value:
		var left_enabled = false# if i == 0 else false
#		var left_enabled = true if i == 0 else false
		var right_enabled = false
#		var right_enabled = true if i < choices else false
		
		# Should we enable choice?
		if i < choices:
			right_enabled = true
			# do we need to spawn a new line?
			if choice_lines.size() <= i:
				var c : Control = choice_line.instance()
				add_child(c)
#				move_child(c, CHOICE_SLOT_START + i)
		
		set_slot(CHOICE_SLOT_START + i, left_enabled, SLOT, in_color, right_enabled, SLOT, out_color)

func to_dictionary() -> Dictionary:
	var d : Dictionary = .to_dictionary()
	d["node_type"] = "DialogNode"
	d["character"] = get_character_text()
	d["mood"] = get_mood_text()
	d["dialog"] = get_dialog_text()
	d["choices"] = []
	
	assert(get_choice_lines().size() == get_connection_output_count())
	
	for i in get_choice_lines().size():
		var choice_text : String = get_choice_lines()[i].text
		var choice_next_id : int = EMPTY_NODE_ID
		
		for c in get_my_connections():
			# it skips the port 0 if it's not open, and turns port 1 into 0, and so on
#			if c.from == self.name and c.from_port == i:
			if c.from_port == i:
				var target : EventNode = get_parent().get_node(c.to)
				choice_next_id = target.get_node_id()
		d["choices"].append({"text": choice_text, "next_id": choice_next_id})
	
	return d
	

func _on_child_tree_exited():
	rect_size = rect_min_size


func _on_ChoicesSpinBox_value_changed(value):
	update_slots(value)
