extends CanvasLayer

var _duration := 0
var _game_over := false

onready var _repute_tracker = $Background/PointTracker as Label
onready var _time_tracker = $Background/TimeTracker as Label


func update_repute(new_value:int)->void:
	_repute_tracker.text = "Repute: " + str(new_value)


func _on_Timer_timeout()->void:
	if not _game_over:
		_duration += 1
		_time_tracker.text = "Time: " + str(_duration)


func _on_Main_game_over()->void:
	_game_over = true
