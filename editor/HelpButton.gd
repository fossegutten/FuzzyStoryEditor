extends Button


export(NodePath) var help_popup_path : NodePath


func _on_HelpButton_pressed():
	var n : PopupPanel = get_node(help_popup_path)
	if n:
		n.popup()
	else:
		printerr("Path not valid: %s" % help_popup_path )
