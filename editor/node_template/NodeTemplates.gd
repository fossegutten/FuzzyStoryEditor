extends MarginContainer

signal node_template_load_request(dictionary)

const BUTTON_SCENE : PackedScene = preload("res://editor/node_template/NodeTemplateButton.tscn")
const TEMPLATE_BUTTONS : int = 50

onready var grid : GridContainer = $VBox/ScrollContainer/GridContainer
onready var save_dialog : ConfirmationDialog = $SaveConfirmationDialog
onready var erase_dialog : ConfirmationDialog = $EraseConfirmationDialog
onready var description_label : Label = $VBox/DescriptionLabel
onready var save_mode_button : CheckButton = $VBox/HBox/SaveModeCheckButton
onready var bg : ColorRect = $ColorRect

enum Mode {
	SAVE,
	LOAD
}
var _current_mode := -1

var immediate_id : int = -1
var immediate_template : Dictionary = {}


func set_current_mode(value : int) -> void:
	_current_mode = value
	
	save_mode_button.pressed = value == Mode.SAVE
	
	if value == Mode.SAVE:
		save_mode_button.pressed = true
		save_mode_button.disabled = false
		bg.color = Color.webmaroon
		_update_description("Press a button to save template:\n" + Global.beautify_dictionary(immediate_template))
	elif value == Mode.LOAD:
		save_mode_button.pressed = false
		save_mode_button.disabled = true
		bg.color = Color.midnightblue
		_update_description("Press a button to create node from template.")


func generate_key(id : int) -> String:
	return "template%03d" % id


func request_template_save(template : Dictionary) -> void:
	if template.size() == 0:
		return
	
	# beware, these are order dependent
	immediate_template = template
	set_current_mode(Mode.SAVE)
	show()


func open() -> void:
	set_current_mode(Mode.LOAD)
	show()


func _ready():
	set_current_mode(Mode.LOAD)
	
	for i in TEMPLATE_BUTTONS:
		var b : TextureButton = BUTTON_SCENE.instance()
		grid.add_child(b)
		b.connect("pressed", self, "_on_NodeTemplateButton_pressed", [b, i])
		b.popup_menu.connect("id_pressed", self, "_on_NodeTemplatePopupMenu_id_pressed", [b, i])
		
		# load from config
		if ConfigSaveLoad.has_value("node_templates", generate_key(i)):
			b.set_template(ConfigSaveLoad.get_value("node_templates", generate_key(i)))
		else:
			b.set_template({})


func _update_description(text : String) -> void:
	description_label.text = text


func save_immediate_template() -> void:
	var button : TextureButton = grid.get_child(immediate_id)
	button.set_template(immediate_template)
	ConfigSaveLoad.set_value("node_templates", generate_key(immediate_id), immediate_template)


func load_template(button : TextureButton, button_id : int) -> void:
	var loaded_template : Dictionary = button.get_template()
	emit_signal("node_template_load_request", loaded_template)


func erase_template(button_id : int) -> void:
	var button : TextureButton = grid.get_child(immediate_id)
	button.set_template({})
	ConfigSaveLoad.set_value("node_templates", generate_key(button_id), null)


func _on_NodeTemplateButton_pressed(button : TextureButton, button_id : int):
	
	immediate_id = button_id
	
	if _current_mode == Mode.SAVE:
		if ConfigSaveLoad.has_value("node_templates", generate_key(button_id)):
			save_dialog.popup(Rect2(get_global_mouse_position() + save_dialog.rect_min_size / 2, save_dialog.rect_size))
		else:
			save_immediate_template()
	
	elif _current_mode == Mode.LOAD:
		load_template(button, button_id)


func _on_NodeTemplatePopupMenu_id_pressed(popup_item_id : int, button : TextureButton, button_id : int) -> void:
	
	immediate_id = button_id
	
	# load
	if popup_item_id == 0:
		load_template(button, button_id)
	
	# duplicate / copy
	elif popup_item_id == 1:
		request_template_save(button.get_template())
		print("copy")
	
	# erase
	elif popup_item_id == 2:
		erase_dialog.popup(Rect2(get_global_mouse_position() + erase_dialog.rect_min_size / 2, erase_dialog.rect_size))


func _on_SaveConfirmationDialog_confirmed():
	save_immediate_template()


func _on_EraseConfirmationDialog_confirmed():
	erase_template(immediate_id)


func _on_SaveModeCheckButton_pressed():
	if save_mode_button.pressed:
		Global.emit_signal("warning_message", "Can't enter save mode this way. Please select a node to save.")
	
	# force load mode and turn button off again
	set_current_mode(Mode.LOAD)


func _on_CloseButton_pressed():
	hide()
