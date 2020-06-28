extends MarginContainer

signal dialog_completed(choice_id)

func start_dialog(character : String, mood : String, bbcode_text : String, choices : Array) -> void:
	
	$Margin/VBox/HBoxLabels/LabelChar.text = character
	$Margin/VBox/HBoxLabels/LabelMood.text = mood
	$Margin/VBox/RichTextLabel.bbcode_text = bbcode_text
	
	# delete all old buttons
	for i in $Margin/VBox/HBoxButtons.get_children():
		$Margin/VBox/HBoxButtons.remove_child(i)
		i.queue_free()
	
	# add new buttons
	for i in choices:
		var button := Button.new()
		button.text = i["text"]
		button.connect("pressed", self, "_on_button_pressed", [ i["next_id"] ])
		$Margin/VBox/HBoxButtons.add_child(button)
	
	show()


func _on_button_pressed(id : int) -> void:
	hide()
	emit_signal("dialog_completed", id)
