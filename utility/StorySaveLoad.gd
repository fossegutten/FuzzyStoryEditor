extends Node

signal save_failed(msg)

var resource_path := "res://saved_story.tres"
var json_path := "res://saved_story.json"

func create_story_resource(node_array : Array) -> FuzzyStory:
	var story := FuzzyStory.new()
	
	for i in node_array:
		assert(i is Dictionary)
		story.add_story_node(i)
	
	return story


func load_resource(resource_path : String) -> FuzzyStory:
	
	var story : FuzzyStory = ResourceLoader.load(resource_path)
	return story


func save_as_resource(node_array : Array, path : String = resource_path) -> void:
	
	# make sure we dont overwrite other resource types
	if ResourceLoader.exists(path):
		var res := ResourceLoader.load(path)
		if !res is FuzzyStory:
			Global.emit_signal("warning_message", "Save failed. Cannot overwrite other resource types")
			return
	
	var story := create_story_resource(node_array)
	
	var err := ResourceSaver.save(path, story)
	if ResourceSaver.save(path, story) != OK:
		Global.emit_signal("warning_message", "Save resource failed. Error code: %s" % err)


func save_as_json(node_array : Array,  path : String, keep_metadata : bool = false) -> void:
	# no reason to keep the metadata for a json file, as we don't import it (yet)
	# it also clutters the json file, which defeats the purpose of a human readable format
	if !keep_metadata:
		for i in node_array:
			if i is Dictionary:
				if i.erase("metadata") == false:
					printerr("Node did not have metadata")
			else:		
				printerr("Node is not a dictionary")
	
	# add tabs
	var json_string : String = JSON.print(node_array, "	", false)
	
	if !validate_json(json_string) == "":
		Global.emit_signal("warning_message", "Save JSON failed. Invalid JSON data")
		return
	
	var file := File.new()
	var err := file.open(path, File.WRITE)
	if err == OK:
		file.store_string(json_string)
		file.close()
	else:
		Global.emit_signal("warning_message", "Save JSON failed. Error code: %s" % err)
