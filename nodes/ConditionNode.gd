extends EventNode


func _ready():
	show_close = true
	resizable = true
	set_slot(0, true, SLOT, in_color, false, SLOT, out_color)
	set_slot(1, false, SLOT, in_color, true, SLOT, out_color)
	set_slot(2, false, SLOT, in_color, true, SLOT, out_color)
