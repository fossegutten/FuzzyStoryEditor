extends EventNode


func _ready():
	set_slot(0, true, SLOT, in_color, true, SLOT, out_color)


func get_checkpoint_text() -> String:
	return $LineEdit.text

func set_checkpoint_text(value : String) -> void:
	$LineEdit.text = value


func to_dictionary() -> Dictionary:
	var d : Dictionary = .to_dictionary()
	d["node_type"] = "CheckpointNode"
	d["checkpoint"] = get_checkpoint_text()
	
	d["next_id"] = EMPTY_NODE_ID
	
	for c in d["metadata"]["connections"]:
		var target : EventNode = get_parent().get_node(c.to)
		d["next_id"] = target.get_node_id()
	
	return d
