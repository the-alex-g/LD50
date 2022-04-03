extends Button

signal custom_pressed


func _on_AudioStreamPlayer_finished()->void:
	emit_signal("custom_pressed")


func _on_Button_pressed()->void:
	$AudioStreamPlayer.play()
