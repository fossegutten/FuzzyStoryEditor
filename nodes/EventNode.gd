extends GraphNode
class_name EventNode

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
func to_dict(graph_edit : GraphEdit) -> Dictionary:
	var d : Dictionary = {
		"node_id": get_node_id(),
		"node_type": "EventNode",
		"metadata": {
				"node_name": name,
				"position": offset,
				"size": rect_size,
				# see below, where we store all connections directly copied from the GraphEdit
				"connections": get_connections(graph_edit)
			},
	}
	return d

func get_connections(graph_edit : GraphEdit) -> Array:
	var connections : Array = []
	for c in graph_edit.get_connection_list():
		if c.from == self.name:
			connections.append(c)
#			node["metadata"]["connections"].append(c)
	return connections


static func new_from_dict(dict : Dictionary) -> EventNode:
	var new_node : EventNode
	
	return new_node
