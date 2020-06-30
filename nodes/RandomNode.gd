extends EventNode

onready var outcomes_spin_box : SpinBox = $ChoicesHBox/OutcomesSpinBox

const OUTCOME_SLOT_START := 1

func _ready():
	set_slot(0, true, SLOT, in_color, false, SLOT, out_color)
	update_slots(outcomes_spin_box.value)
	
	to_dict(GraphEdit.new())

func to_dict(graph_edit : GraphEdit) -> Dictionary:
	var d : Dictionary = .to_dict(graph_edit)
	d.node_type = "RandomNode"
	
	print(d)
	return d

func update_slots(choices : int) -> void:
	assert(choices > 0)
	
	var outcome_lines : Array = []
	for i in get_children():
		if i is Label:
#		if i.is_in_group("choice_line"):
			outcome_lines.append(i)
	
	for i in outcome_lines.size():
		if i > choices - 1:
			var c : Control = outcome_lines[outcome_lines.size() - 1]
			outcome_lines.remove(outcome_lines.size() - 1)
			c.connect("tree_exited", self, "_on_child_tree_exited")
			c.queue_free()
	
	for i in outcomes_spin_box.max_value:
		var right_enabled = false
		
		# Should we enable choice?
		if i < choices:
			right_enabled = true
			# do we need to spawn a new line?
			if outcome_lines.size() <= i:
				var c := Label.new()
				c.align = Label.ALIGN_RIGHT
				c.text = "%d" % i
				add_child(c)
#				move_child(c, OUTCOME_SLOT_START + i)
		
		set_slot(OUTCOME_SLOT_START + i, false, SLOT, in_color, right_enabled, SLOT, out_color)


func _on_child_tree_exited():
	rect_size = rect_min_size


func _on_OutcomesSpinBox_value_changed(value):
	update_slots(value)
