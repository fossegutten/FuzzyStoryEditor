extends Node

onready var expression : Expression  = Expression.new()

# Used as a kinda hacky "nullable value type(boolean)"
# Returns null if there is an error
func parse(command : String):
	var error : int = expression.parse(command, [])
	if error != OK:
		printerr(expression.get_error_text())
		return null
	
	var result = expression.execute([], null, true)
	if expression.has_execute_failed():
		printerr("Expression execution failed for command '%s'" % command)
	
	return result
