extends Panel

signal load_request(path)
signal save_request(path)

var file_dialog_size := Vector2(600, 400)
var confirmation_dialog_size := Vector2(300, 100)

export(NodePath) var graph_edit_path : NodePath
#enum {
#	LOAD,
#	SAVE
#}
#
#var current_mode : int = -1
var current_load_path : String = ""

func _ready():
	hide()


func open_load_panel() -> void:
	show()
	$FileDialogLoad.popup_centered(file_dialog_size)

func open_save_panel() -> void:
	show()
	$FileDialogSave.popup_centered(file_dialog_size)

# max 3 lines text for now
func open_confirmation_panel(title : String, text : String = "") -> void:
	$ConfirmationDialogLoad.window_title = title
	$ConfirmationDialogLoad.popup_centered(confirmation_dialog_size)
#	$ConfirmationDialogLoad/Margin/Label.text = text


func _on_Dialog_popup_hide():
	# don't close if confirmation dialog just popped
	if !$ConfirmationDialogLoad.visible:
		hide()


func _on_FileDialogLoad_file_selected(path):
	
	var prompt : bool = false
	
	var graph_edit : EventEdit = get_node(graph_edit_path)
	
	if graph_edit:
		if graph_edit.get_event_nodes().size() > 0:
			prompt = true
	
	if prompt:
		current_load_path = path
		open_confirmation_panel("Are you sure you want to load?")
	else:
		emit_signal("load_request", path)


func _on_FileDialogSave_file_selected(path):
	# save dialog has a confirmation prompt built in, for when file exists
	emit_signal("save_request", path)
	print("save requested")


func _on_ConfirmationDialogLoad_confirmed():
	print("load requested")
	emit_signal("load_request", current_load_path)
