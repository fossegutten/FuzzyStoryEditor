extends GraphNode
class_name DWNode

const DEFAULT_SLOT := 0

onready var choice_line : PackedScene = preload("res://nodes/DialogChoice.tscn")
onready var choice_spin_box : SpinBox = $HBox/ChoicesSpinBox

var node_id : int = -1 setget set_node_id, get_node_id


func set_node_id(value : int) -> void:
	node_id = value


func get_node_id() -> int:
	return node_id


func _ready():
	show_close = true
	resizable = true
	update_slots(choice_spin_box.value)
#	rect_size = Vector2(200, 100)
#	set_slot(0, true, 0, Color.white, true, 0, Color.white)
#	set_slot(1, false, 0, Color.white, true, 0, Color.white)
#	set_slot(2, false, 0, Color.white, true, 0, Color.white)
#	var label = Label.new()
#	var label2 = Label.new()
#	label2.align = Label.ALIGN_RIGHT
#	var label3 = Label.new()
#	label3.align = Label.ALIGN_RIGHT
#	label.text = "test"
#	label2.text = "test2"
#	label3.text = "test3"
##	add_child(label)
##	set_slot(1, false, 1, Color.white, true, 1, Color.white)
##	add_child(label2)
##	add_child(label3)
##	set_conn
#	print(get_connection_output_count())
#	print(get_connection_input_count())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
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
			c.queue_free()
		
	
	for i in choice_spin_box.max_value:
		var left_enabled = true if i == 0 else false
		var right_enabled = false
#		var right_enabled = true if i < choices else false
		
		# Should we enable choice?
		if i < choices:
			right_enabled = true
			# do we need to spawn a new line?
			if choice_lines.size() <= i:
				var c : Control = choice_line.instance()
				add_child(c)
				move_child(c, i)
		
		set_slot(i, left_enabled, DEFAULT_SLOT, Color.yellow, right_enabled, DEFAULT_SLOT, Color.green)


func _on_ChoicesSpinBox_value_changed(value):
	update_slots(value)
