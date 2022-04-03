extends Control


func _ready()->void:
	$VBoxContainer/Fullscreen.pressed = OS.window_fullscreen


func _on_Button_pressed()->void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main/Main.tscn")


func _on_Fullscreen_toggled(button_pressed:bool)->void:
	OS.window_fullscreen = button_pressed
