extends EventNode
#class_name DialogNode


onready var choice_line : PackedScene = preload("res://nodes/controls/DialogChoiceLine.tscn")
onready var choice_spin_box : SpinBox = $ChoicesHBox/ChoicesSpinBox

const CHOICE_SLOT_START := 4

func _ready():
	show_close = true
	resizable = true
	set_slot(0, true, SLOT, Color.yellow, false, SLOT, Color.green)
	update_slots(choice_spin_box.value)


func update_slots(choices : int) -> void:
	assert(choices > 0)
	
	var choice_lines : Array = []
	for i in get_children():
		if i.is_in_group("choice_line"):
			choice_lines.append(i)
	
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
		
		set_slot(CHOICE_SLOT_START + i, left_enabled, SLOT, Color.yellow, right_enabled, SLOT, Color.green)


func _on_child_tree_exited():
	rect_size = rect_min_size


func _on_ChoicesSpinBox_value_changed(value):
	update_slots(value)