extends Control


func _ready()->void:
	$VBoxContainer/Fullscreen.pressed = OS.window_fullscreen


func _on_Continue_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main/Main.tscn")


func _on_Checkbox_clicked(is_pressed:bool)->void:
	OS.window_fullscreen = is_pressed
