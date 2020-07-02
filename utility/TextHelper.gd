extends Node

# credit to https://github.com/EXPWorlds for these tag methods

func get_tagged_text(tag : String, text : String) -> String:
	var start_tag : String = "<" + tag + ">"
	var end_tag : String = "</" + tag + ">"
	var start_index : int = text.find(start_tag) + start_tag.length()
	var end_index : int = text.find(end_tag)
	var substr_length : int = end_index - start_index
	return text.substr(start_index, substr_length)


func inject_variables(text : String) -> String:
	var variable_count : int = text.count("<var>")
	assert(variable_count == text.count("</var>"))
	
	for i in range(variable_count):
		var variable_name : String = get_tagged_text("var", text)
		# assumes we have global autoload class Registry 
		var variable_value = Registry.lookup(variable_name)
		var start_index : int = text.find("<var>")
		var end_index : int = text.find("</var>") + "</var>".length()
		var substr_length : int = end_index - start_index
		text.erase(start_index, substr_length)
		text = text.insert(start_index, str(variable_value))
	
	return text


