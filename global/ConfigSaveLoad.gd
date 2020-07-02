extends Node

const SAVE_FOLDER : String = "user://"
const SAVE_FILE = "fuzzy_config.cfg"


func open_config_folder() -> void:
	OS.shell_open(OS.get_user_data_dir())


# set a value to null, to erase it
func set_value(section : String, key : String, value) -> void:
	var file : ConfigFile = ConfigFile.new()
	
	var dir : Directory = Directory.new()
	if not dir.dir_exists(SAVE_FOLDER):
		var error : int = dir.make_dir_recursive(SAVE_FOLDER)
		if error != OK:
			printerr("Could not create directiory. Not saving config")
			return
	
	var save_path : String = SAVE_FOLDER.plus_file(SAVE_FILE)
	file.load(save_path)
	file.set_value(section, key, value)
	assert(file.save(save_path) == OK)


# returns null if no value
func get_value(section : String, key : String):
	var file : ConfigFile = ConfigFile.new()
	var save_path : String = SAVE_FOLDER.plus_file(SAVE_FILE)
	if file.load(save_path) == OK:
		if file.has_section_key(section, key):
			return file.get_value(section, key)
	return null



func get_section_keys(section : String) -> PoolStringArray:
	var file : ConfigFile = ConfigFile.new()
	var save_path : String = SAVE_FOLDER.plus_file(SAVE_FILE)
	if file.load(save_path) == OK:
		if file.has_section(section):
			return file.get_section_keys(section)
	return PoolStringArray()



func has_value(section : String, key : String) -> bool:
	var file : ConfigFile = ConfigFile.new()
	var save_path : String = SAVE_FOLDER.plus_file(SAVE_FILE)
	if file.load(save_path) == OK:
		return file.has_section_key(section, key)
	return false
