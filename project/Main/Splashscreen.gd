extends Control


func _on_Button_pressed()->void:
	get_tree().change_scene("res://Main/Main.tscn")


func _on_Fullscreen_toggled(button_pressed:bool)->void:
	OS.window_fullscreen = button_pressed
