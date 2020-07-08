extends Control

onready var add_node_popup_menu : PopupMenu = $AddNodePopupMenu
onready var add_node_menu_button : MenuButton = $VBox/HBox/AddNodeMenuButton
onready var graph_edit : GraphEdit = $VBox/HBox2/StoryGraphEdit
onready var node_templates : Control = $VBox/HBox2/NodeTemplates

const POPUP_MENU_SIZE := Vector2(100, 100)


func _ready():
	var p : PopupMenu = add_node_menu_button.get_popup()
	p.connect("id_pressed", self, "_on_AddNodeMenuButton_id_pressed")
	
	for i in EventNode.NodeType.size():
		for j in [add_node_popup_menu, add_node_menu_button.get_popup()]:
			# capitalize also removes underscores
			var s : String = EventNode.NodeType.keys()[i].to_lower().capitalize()#.replace("_", " ")
			j.add_item(s, i)


func _on_StoryGraphEdit_right_clicked(position):
	add_node_popup_menu.popup(Rect2(get_global_mouse_position(), POPUP_MENU_SIZE))


func _on_AddNodeMenuButton_id_pressed(id):
	var node : EventNode = graph_edit.create_node_from_enum(id)
	node.offset = graph_edit.update_node_offset(Vector2(40, 40), false)


func _on_AddNodePopupMenu_id_pressed(id):
	var node : EventNode = graph_edit.create_node_from_enum(id)
	node.offset = graph_edit.update_node_offset(add_node_popup_menu.rect_global_position, true)

### STORY
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
	
	# make sure the old nodes are removed before we load in new ones, to prevent ID conflicts
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	var story : FuzzyStory = $StorySaveLoad.load_resource(path)
	graph_edit.deserialize_event_nodes(story)


func _on_FileDialogPanel_save_request(path):
	$StorySaveLoad.save_as_resource(graph_edit.serialize_event_nodes(), path)


func _on_FileDialogPanel_export_request(path):
	$StorySaveLoad.save_as_json(graph_edit.serialize_event_nodes(), path)


func _on_TestStoryButton_pressed():
	var story : FuzzyStory = $StorySaveLoad.create_story_resource(graph_edit.serialize_event_nodes())
	$StoryPlayer.start("start", story)

### NODE TEMPLATES
func _on_NodeTemplatesButton_pressed():
	if node_templates.visible:
		node_templates.hide()
	else:
		node_templates.open()


func _on_SaveNodeButton_pressed():
	graph_edit.save_selected_node_as_template()


func _on_StoryGraphEdit_save_node_template_request(dictionary):
	node_templates.request_template_save(dictionary)


func _on_NodeTemplates_node_template_load_request(dictionary):
	if dictionary.size() == 0:
		return
	
	# we have to create a new unique ID for the node
	dictionary["node_id"] = graph_edit.generate_free_node_id()
	dictionary["metadata"]["position"] = graph_edit.update_node_offset(Vector2(40, 40), false)
	
	var node : EventNode = graph_edit.create_node_from_dictionary(dictionary)
#	node.offset = graph_edit.update_node_offset(add_node_popup_menu.rect_global_position, true)

