extends Node

onready var expression : Expression  = Expression.new()

onready var my_test_class := TestClass.new()


# credit to https://github.com/EXPWorlds


# Called when the node enters the scene tree for the first time.
func _ready():
	
	print(_inject_variables("<var>P1_Level</var>"))
	print(_inject_variables("<var>P2_Level</var>"))
	print(_inject_variables("<var>Tiasme</var>"))
#	print(my_test_class.my_name)
	
#	parse_expression(my_test_class, "my_name == Joe")
#	parse_expression(my_test_class, "Joe == my_name")
#	parse_expression(my_test_class, "Joe == Joe")
#	parse_expression(my_test_class, "my_test_class.get('my_name') == Joe")
	
#	_on_text_entered("sqrt(pow(3,2) + pow(4,2))")
#	_on_text_entered('Global.get("my_name") == "Ola"')
#	_on_text_entered("Joe == my_name")
#	print("wow")
	pass # Replace with function body.



func _inject_variables(text : String) -> String:
	var variable_count : int = text.count("<var>")
	assert(variable_count == text.count("</var>"))
	
	for i in range(variable_count):
		var variable_name := _get_tagged_text("var", text)
		# assumes we have global autoload class Registry 
		var variable_value = Registry.lookup(variable_name)
		var start_index = text.find("<var>")
		var end_index = text.find("</var>") + "</var>".length()
		var substr_length = end_index - start_index
		text.erase(start_index, substr_length)
		text = text.insert(start_index, str(variable_value))
	
	return text

func _get_tagged_text(tag : String, text : String) -> String:
	var start_tag = "<" + tag + ">"
	var end_tag = "</" + tag + ">"
	var start_index = text.find(start_tag) + start_tag.length()
	var end_index = text.find(end_tag)
	var substr_length = end_index - start_index
	return text.substr(start_index, substr_length)


func _on_text_entered(command):
	var error = expression.parse(command, ['Global'])
	if error != OK:
		print(expression.get_error_text())
		return
#	var result = expression.execute(['Global'], null, true)
	var result = expression.execute([], my_test_class, true)
#	var result = expression.execute([], null, true)
	if not expression.has_execute_failed():
		print("Result %s" % result)
#        $LineEdit.text = str(result)


func parse_expression(p_class : Object, command : String ) -> bool:
	
	var inputs : Array = ['my_test_class']
#	var inputs : Array = []
	
	var error : int = expression.parse(command, inputs)
	if error != OK:
		printerr(expression.get_error_text())
		return false
	
	var result = expression.execute(['my_test_class'], null, true)
#	var result = expression.execute([p_class], null, true)
#	var result = expression.execute(inputs, p_class, true)
	print(result)
#	var result = expression.execute([], null, true)
	if not expression.has_execute_failed():
		print("Result %s" % result)
	
	return false


class TestClass:
	
#	var Joe : String  = "kek"
	var my_name : String = "Joe"
