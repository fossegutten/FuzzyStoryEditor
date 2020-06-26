extends Node

var resource_path := "res://saved_story.tres"
var json_path := "res://saved_story.json"

func load_resource(resource_path : String) -> Array:
	
	var story : FuzzyStory = ResourceLoader.load(resource_path)
	
	return story.story_nodes


func save_as_resource(node_array : Array, path : String = resource_path) -> void:
	
	var story := FuzzyStory.new()
	
	for i in node_array:
		assert(i is Dictionary)
		story.add_story_node(i)
	
#	var dir := Directory.new()
#	if dir.file_exists(path):
#		dir.remove(path)
#		print("kek")
#	print(story)
	ResourceSaver.save(path, story)


func save_as_json(node_array : Array,  path : String = json_path, keep_metadata : bool = false) -> void:
	
	# no reason to keep the metadata for a json file, as we don't import it (yet)
	# it also clutters the json file, which defeats the purpose of a human readable format
	if !keep_metadata:
		for i in node_array:
			if i is Dictionary:
				if i.erase("metadata") == false:
					printerr("Node did not have metadata")
			else:		
				printerr("Node is not a dictionary")
	
	var json_string : String = JSON.print(node_array, "	", true)
		
	var file := File.new()
	file.open(path, File.WRITE)
	file.store_string(json_string)
	file.close()

