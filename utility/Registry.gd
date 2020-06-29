extends Node


var registry : Dictionary = {
	"Time": OS.get_time(),
	"P1_Level": get_player_level(1),
	"P2_Level": get_player_level(2)
}

var my_name : String = "Ola"


func lookup(key : String):
	if registry.has(key):
		return registry[key]
	else:
		printerr("Key '%s' was not found in the registry. Returning Null" % key)
		return null


func get_player_level(player_id : int) -> int:
	
	if player_id == 1:
		return 95
	elif player_id == 2:
		return 78
	else:
		return -1
