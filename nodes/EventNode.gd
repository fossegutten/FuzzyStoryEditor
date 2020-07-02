extends GraphNode
class_name EventNode

const EMPTY_NODE_ID := -1

# there is only one slot type, so use this
const SLOT := 0

enum NodeType {
	CHECKPOINT,
	CONDITION,
	DIALOG,
	FUNCTION_CALL,
	JUMP,
	RANDOM
}

export(Color) var in_color := Color.white
export(Color) var out_color := Color.white

var node_id : int = -1 setget set_node_id, get_node_id


func set_node_id(value : int) -> void:
	node_id = value


func get_node_id() -> int:
	return node_id


# TODO implement this instead of the "parser" script
func to_dictionary() -> Dictionary:
	var d : Dictionary = {
		"node_id": get_node_id(),
		"node_type": "EventNode",
		"metadata": {
				"node_name": name, # node name should not be needed for anything
				"position": offset,
				"size": rect_size,
				"connections": get_my_connections()
			},
	}
	return d


# We should always be children of a GraphEdit, so we can ask parent for connections
func get_my_connections() -> Array:
	var connections : Array = []
	if get_parent() is GraphEdit:
		for c in get_parent().get_connection_list():
			if c.from == self.name:
				connections.append(c)
	return connections
