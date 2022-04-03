extends CanvasLayer

signal spawn_agent()
signal reduce_refill_time()

const FLASK_COST := 2
const AGENT_COST := 3
const REPUTE_MODIFIER := 1
const MIN_TIME_TO_LOSE := 57

var _duration := 0
var _game_over := false
var _repute := 0

onready var _repute_tracker = $Background/PointTracker as Label
onready var _time_tracker = $Background/TimeTracker as Label
onready var _flask_button = $Background/VBoxContainer/Flask as Button
onready var _agent_button = $Background/VBoxContainer/Agent as Button
onready var _score_tracker = $GameOverPanel/VBoxContainer/Score as Label
onready var _game_over_panel = $GameOverPanel as Panel


func _ready()->void:
	_update_repute(0)


func increment_repute()->void:
	_update_repute(_repute + 1)


func _update_repute(new_value:int)->void:
	_repute = new_value
	_repute_tracker.text = "Repute: " + str(_repute)
	_flask_button.disabled = _repute < FLASK_COST
	_agent_button.disabled = _repute < AGENT_COST


func _on_Timer_timeout()->void:
	if not _game_over:
		_duration += 1
		_time_tracker.text = "Time: " + str(_duration)


func _on_Main_game_over()->void:
	_game_over = true
	_game_over_panel.visible = true
	_score_tracker.text = "Your score is " + str(_duration + _repute * REPUTE_MODIFIER - MIN_TIME_TO_LOSE)


func _on_Flask_pressed()->void:
	emit_signal("reduce_refill_time")
	_update_repute(_repute - FLASK_COST)


func _on_Agent_pressed()->void:
	emit_signal("spawn_agent")
	_update_repute(_repute - AGENT_COST)
