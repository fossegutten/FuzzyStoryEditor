extends GraphNode
class_name EventNode

const SLOT := 0

export(Color) var in_color := Color.white
export(Color) var out_color := Color.white

var node_id : int = -1 setget set_node_id, get_node_id


func set_node_id(value : int) -> void:
	node_id = value


func get_node_id() -> int:
	return node_id
