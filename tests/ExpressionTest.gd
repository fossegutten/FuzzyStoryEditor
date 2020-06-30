extends Node


onready var my_test_class := TestClass.new()

onready var text_helper : Node = $TextHelper
onready var expression_parser : Node = $ExpressionParser


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var test1 = text_helper.inject_variables("<var>P1_Level</var>")
	var test2 = text_helper.inject_variables("<var>P1_Level</var>")
	var test3 = text_helper.inject_variables("<var>P1_Level</var>")
	
#	print(expression_parser.parse("asd%ssad 1 = k e 3" % test1))
	print(expression_parser.parse("%s == 925" % test1))
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




#func _on_text_entered(command):
#	var error = expression.parse(command, ['Global'])
#	if error != OK:
#		print(expression.get_error_text())
#		return
##	var result = expression.execute(['Global'], null, true)
#	var result = expression.execute([], my_test_class, true)
##	var result = expression.execute([], null, true)
#	if not expression.has_execute_failed():
#		print("Result %s" % result)
##        $LineEdit.text = str(result)


#func parse_expression(p_class : Object, command : String ) -> bool:
#
#	var inputs : Array = ['my_test_class']
##	var inputs : Array = []
#
#	var error : int = expression.parse(command, inputs)
#	if error != OK:
#		printerr(expression.get_error_text())
#		return false
#
#	var result = expression.execute(['my_test_class'], null, true)
##	var result = expression.execute([p_class], null, true)
##	var result = expression.execute(inputs, p_class, true)
#	print(result)
##	var result = expression.execute([], null, true)
#	if not expression.has_execute_failed():
#		print("Result %s" % result)
#
#	return false


class TestClass:
	
#	var Joe : String  = "kek"
	var my_name : String = "Joe"
