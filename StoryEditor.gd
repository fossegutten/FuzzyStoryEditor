extends Control

onready var graph_edit : GraphEdit = $VBox/HBox2/StoryGraphEdit
onready var add_node_popup_menu : PopupMenu = $AddNodePopupMenu
onready var add_node_menu_button : MenuButton = $VBox/HBox2/VBox/AddNodeMenuButton

const POPUP_MENU_SIZE := Vector2(100, 100)


func _ready():
	
	var p : PopupMenu = add_node_menu_button.get_popup()
	p.connect("id_pressed", self, "_on_AddNodeMenuButton_id_pressed")
	
	for i in [add_node_popup_menu, add_node_menu_button.get_popup()]:
		i.add_item("Dialog", EventNode.NodeType.DIALOG)
		i.add_item("Checkpoint", EventNode.NodeType.CHECKPOINT)
		i.add_item("Condition", EventNode.NodeType.CONDITION)
		i.add_item("FunctionCall", EventNode.NodeType.FUNCTION_CALL)
		i.add_item("Random", EventNode.NodeType.RANDOM)


func _on_StoryGraphEdit_right_clicked(position):
	add_node_popup_menu.popup(Rect2(get_global_mouse_position(), POPUP_MENU_SIZE))
	graph_edit.set_new_node_offset(get_global_mouse_position(), true)


func _on_AddNodeMenuButton_id_pressed(id):
	
	var step : Vector2 = Vector2(40, 40)
	var target_pos : Vector2 = step
	
	while(graph_edit.has_node_in_position(target_pos, false)):
		target_pos += step
	
	graph_edit.set_new_node_offset(target_pos, false)
	
	graph_edit.create_node_from_enum(id)


func _on_AddNodePopupMenu_id_pressed(id):
	graph_edit.create_node_from_enum(id)


func _on_NewButton_pressed():
	$FileDialogPanel.open_new_confirmation_dialog()


func _on_LoadButton_pressed():
	$FileDialogPanel.open_load_dialog()


func _on_SaveButton_pressed():
	$FileDialogPanel.open_save_dialog()


func _on_ExportButton_pressed():
	$FileDialogPanel.open_export_dialog()


func _on_FileDialogPanel_new_request():
	graph_edit.clear_all_event_nodes()


func _on_FileDialogPanel_load_request(path):
	graph_edit.clear_all_event_nodes()
	
	# make sure the old nodes are removed before we load in new ones
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	var res : FuzzyStory = $StorySaveLoad.load_resource(path)
	$StoryParser.array_to_graph(graph_edit, res)


func _on_FileDialogPanel_save_request(path):
	var arr : Array = $StoryParser.graph_to_array(graph_edit, graph_edit.get_event_nodes())
	$StorySaveLoad.save_as_resource(arr, path)


func _on_FileDialogPanel_export_request(path):
	var arr : Array = $StoryParser.graph_to_array(graph_edit, graph_edit.get_event_nodes())
	$StorySaveLoad.save_as_json(arr)
