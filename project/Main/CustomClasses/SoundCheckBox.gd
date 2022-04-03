extends CheckBox

signal clicked(is_pressed)

var _pressed := false

func _on_Checkbox_toggled(button_pressed:bool)->void:
	$AudioStreamPlayer.play()
	_pressed = button_pressed


func _on_AudioStreamPlayer_finished()->void:
	emit_signal("clicked", _pressed)
