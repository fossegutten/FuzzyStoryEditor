extends Node


func get_tagged_text(tag : String, text : String) -> String:
	var start_tag = "<" + tag + ">"
	var end_tag = "</" + tag + ">"
	var start_index = text.find(start_tag) + start_tag.length()
	var end_index = text.find(end_tag)
	var substr_length = end_index - start_index
	return text.substr(start_index, substr_length)


# credit to https://github.com/EXPWorlds
func inject_variables(text : String) -> String:
	var variable_count : int = text.count("<var>")
	assert(variable_count == text.count("</var>"))
	
	for i in range(variable_count):
		var variable_name := get_tagged_text("var", text)
		# assumes we have global autoload class Registry 
		var variable_value = Registry.lookup(variable_name)
		var start_index = text.find("<var>")
		var end_index = text.find("</var>") + "</var>".length()
		var substr_length = end_index - start_index
		text.erase(start_index, substr_length)
		text = text.insert(start_index, str(variable_value))
	
	return text


