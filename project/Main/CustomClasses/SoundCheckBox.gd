extends CheckBox

signal clicked(is_pressed)


func _on_Checkbox_toggled(button_pressed:bool)->void:
	$AudioStreamPlayer.play()


func _on_AudioStreamPlayer_finished()->void:
	emit_signal("clicked")
