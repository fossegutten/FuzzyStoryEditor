extends Node

signal warning_message(msg)

const NODE_SCENES : Dictionary = {
	"DialogNode": preload("res://nodes/DialogNode.tscn"),
	"ConditionNode": preload("res://nodes/ConditionNode.tscn"),
	"CheckpointNode": preload("res://nodes/CheckpointNode.tscn"),
	"FunctionCallNode": preload("res://nodes/FunctionCallNode.tscn"),
	"JumpNode": preload("res://nodes/JumpNode.tscn"),
	"RandomNode":  preload("res://nodes/RandomNode.tscn")
}

# TODO this could use some refactoring, but it works for now
static func beautify_dictionary(d : Dictionary, indents : int = 0) -> String:
	var s : String
	for i in d.size():
		var key : String = d.keys()[i]
		var value = d.values()[i]
		var value_string : String = ""
		
		if typeof(value) == TYPE_DICTIONARY:
			value_string = "\n%s\n" % beautify_dictionary(value, indents + 1)
		elif typeof(value) == TYPE_ARRAY:
			value_string = "\n%s%s" % [create_indent_str(indents + 1), str(value)]
		else:
			value_string = str(value)
		
		s += create_indent_str(indents)
		
		s += "%s: %s" % [key, value_string]
		
		if i != d.size() -1:
			s += "\n"
	
	return s


static func create_indent_str(indents : int) -> String:
	var s : String
	for i in indents:
		s += "-"
		if i == indents - 1:
			s += " "
	return s
	
