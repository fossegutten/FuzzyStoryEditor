extends Panel

signal new_request()
signal load_request(path)
signal save_request(path)
signal export_request(path)

var file_dialog_size := Vector2(600, 400)
var confirmation_dialog_size := Vector2(300, 100)

export(NodePath) var graph_edit_path : NodePath

var current_load_path : String = ""


func _ready():
	Global.connect("warning_message", self, "_on_Global_warning_message")
	hide()


func open_new_confirmation_dialog() -> void:
	show()
	$ConfirmationDialogNew.popup_centered(confirmation_dialog_size)


func open_load_dialog() -> void:
	show()
	$FileDialogLoad.popup_centered(file_dialog_size)


func open_save_dialog() -> void:
	show()
	$FileDialogSave.popup_centered(file_dialog_size)


func open_export_dialog() -> void:
	show()
	$FileDialogExport.popup_centered(file_dialog_size)

# max 3 lines text for now
func open_load_confirmation_dialog(title : String, text : String = "") -> void:
	$ConfirmationDialogLoad.window_title = title
	$ConfirmationDialogLoad.popup_centered(confirmation_dialog_size)
#	$ConfirmationDialogLoad.dialog_text = text


func _on_Dialog_popup_hide():
	# don't close if confirmation dialog just popped
	if !$ConfirmationDialogLoad.visible and !$WarningDialog.visible:
		hide()


func _on_FileDialogLoad_file_selected(path):
	
	# load dialog does not have a confirmation prompt built in, like for saving
	# so we make our own!
	var prompt : bool = false
	
	var graph_edit : EventEdit = get_node(graph_edit_path)
	
	if graph_edit:
		if graph_edit.get_event_nodes().size() > 0:
			prompt = true
	
	if prompt:
		current_load_path = path
		open_load_confirmation_dialog("Are you sure you want to clear all nodes?")
	else:
		emit_signal("load_request", path)


func _on_FileDialogSave_file_selected(path):
	emit_signal("save_request", path)


func _on_ConfirmationDialogLoad_confirmed():
	print("load requested")
	emit_signal("load_request", current_load_path)


func _on_ConfirmationDialogNew_confirmed():
	emit_signal("new_request")


func _on_FileDialogExport_file_selected(path):
	emit_signal("export_request", path)


func _on_Global_warning_message(msg):
	$WarningDialog.dialog_text = msg
	$WarningDialog.popup_centered(confirmation_dialog_size)
	show()
