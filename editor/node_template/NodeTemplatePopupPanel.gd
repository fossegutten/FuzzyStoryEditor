extends PopupPanel

const BUTTON_SCENE : PackedScene = preload("res://editor/node_template/NodeTemplateButton.tscn")

const TEMPLATE_BUTTONS : int = 50

onready var option_button : OptionButton = $VBoxContainer/HBoxContainer/OptionButton
onready var grid : GridContainer = $VBoxContainer/ScrollContainer/GridContainer

enum Mode {
	SAVE,
	LOAD,
	ERASE
}
var _current_mode := -1


var immediate_template : Dictionary = {"test": 1}


func set_current_mode(value : int) -> void:
	_current_mode = value


func generate_key(id : int) -> String:
	return "template%03d" % id


# TODO popup for edit/erase/load
# TODO popup when save request, with slot selection and confirmation dialog if data exists (overwrite)
	# update immediate template before saving


func _ready():
	
	set_current_mode(option_button.selected)
	
	for i in TEMPLATE_BUTTONS:
		var b : TextureButton = BUTTON_SCENE.instance()
		grid.add_child(b)
		b.connect("pressed", self, "_on_NodeTemplateButton_pressed", [b, i])
		
		# load from config
		if ConfigSaveLoad.has_value("node_templates", generate_key(i)):
			b.set_template(ConfigSaveLoad.get_value("node_templates", generate_key(i)))


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			popup()


func _on_NodeTemplateButton_pressed(button : TextureButton, id : int):
	
	if _current_mode == Mode.SAVE:
		button.set_template(immediate_template)
		ConfigSaveLoad.set_value("node_templates", generate_key(id), immediate_template)
	
	elif _current_mode == Mode.LOAD:
		
		# TODO create node, similar to add node button in editor
		var loaded_template : Dictionary = button.get_template()
		
	elif _current_mode == Mode.ERASE:
		button.set_template({})
		ConfigSaveLoad.set_value("node_templates", generate_key(id), null)
#	print("pressed %s %s" % [button, id])


func _on_OptionButton_item_selected(index):
	set_current_mode(index)
#	print(index, " selected")
