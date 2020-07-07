extends PopupPanel

signal node_template_load_request(dictionary)

const BUTTON_SCENE : PackedScene = preload("res://editor/node_template/NodeTemplateButton.tscn")

const TEMPLATE_BUTTONS : int = 50

onready var option_button : OptionButton = $VBoxContainer/HBoxContainer/OptionButton
onready var grid : GridContainer = $VBoxContainer/ScrollContainer/GridContainer
onready var save_dialog : ConfirmationDialog = $SaveConfirmationDialog


enum Mode {
	SAVE,
	LOAD,
	ERASE
}
var _current_mode := -1

var immediate_id : int = -1
var immediate_template : Dictionary = {}


func set_current_mode(value : int) -> void:
	_current_mode = value


func generate_key(id : int) -> String:
	return "template%03d" % id


func request_template_save(template : Dictionary) -> void:
	set_current_mode(Mode.SAVE)
	immediate_template = template
	popup()


func open() -> void:
	set_current_mode(Mode.LOAD)
	popup()


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


func save_immediate_template() -> void:
	var button : TextureButton = grid.get_child(immediate_id)
	button.set_template(immediate_template)
	ConfigSaveLoad.set_value("node_templates", generate_key(immediate_id), immediate_template)

func _on_NodeTemplateButton_pressed(button : TextureButton, id : int):
	
	immediate_id = id
	
	if _current_mode == Mode.SAVE:
		if ConfigSaveLoad.has_value("node_templates", generate_key(id)):
			save_dialog.popup()
		else:
#			button.set_template(immediate_template)
#			ConfigSaveLoad.set_value("node_templates", generate_key(id), immediate_template)
			save_immediate_template()
	
	elif _current_mode == Mode.LOAD:
		
		# TODO create node, similar to add node button in editor
		var loaded_template : Dictionary = button.get_template()
		emit_signal("node_template_load_request", loaded_template)
		
	elif _current_mode == Mode.ERASE:
		button.set_template({})
		ConfigSaveLoad.set_value("node_templates", generate_key(id), null)
#	print("pressed %s %s" % [button, id])


func _on_OptionButton_item_selected(index):
	set_current_mode(index)


func _on_SaveConfirmationDialog_confirmed():
	save_immediate_template()
