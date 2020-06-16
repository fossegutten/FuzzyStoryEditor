extends GraphNode
class_name DWNode

var node_id : int = -1 setget set_node_id, get_node_id


func set_node_id(value : int) -> void:
	node_id = value


func get_node_id() -> int:
	return node_id



# Called when the node enters the scene tree for the first time.
func _ready():
	show_close = true
	resizable = true
#	rect_size = Vector2(200, 100)
	set_slot(0, true, 0, Color.white, true, 0, Color.white)
	set_slot(1, false, 0, Color.white, true, 0, Color.white)
	set_slot(2, false, 0, Color.white, true, 0, Color.white)
	var label = Label.new()
	var label2 = Label.new()
	label2.align = Label.ALIGN_RIGHT
	var label3 = Label.new()
	label3.align = Label.ALIGN_RIGHT
	label.text = "test"
	label2.text = "test2"
	label3.text = "test3"
#	add_child(label)
#	set_slot(1, false, 1, Color.white, true, 1, Color.white)
#	add_child(label2)
#	add_child(label3)
#	set_conn
	print(get_connection_output_count())
#	print(get_connection_input_count())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
