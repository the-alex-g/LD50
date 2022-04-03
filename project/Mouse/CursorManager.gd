class_name CursorManager
extends Node2D

onready var _mouse_follower := $AnimatedSprite


func _ready()->void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(_delta:float)->void:
	var mouse_position := get_global_mouse_position()
	_mouse_follower.global_position = mouse_position


func empty()->void:
	_mouse_follower.frame = 0
	_mouse_follower.play("Dumping")


func update_anim_time(new_anim_time:float)->void:
	new_anim_time -= 0.6
	_mouse_follower.frames.set_animation_speed("Filling", 15.0 / new_anim_time)


func _on_AnimatedSprite_animation_finished()->void:
	if _mouse_follower.animation == "Dumping":
		_mouse_follower.play("Filling")
