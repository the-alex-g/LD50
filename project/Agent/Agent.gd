extends Node2D

signal probe(probe_position)

const NEXT_DIRECTION := [Vector2(32, 0), Vector2(0, 32), Vector2(-32, 0), Vector2(0, -32)]
const ANGLE := [0, TAU / 4, TAU / 2, 3 * TAU / 4]
const MAX_MOVES := 20

var _moves := 0
var _dead := false

onready var _tween = $Tween as Tween
onready var _sprite = $AnimatedSprite as AnimatedSprite


func _ready()->void:
	_move()


func _on_Tween_tween_all_completed()->void:
	if not _dead:
		emit_signal("probe", position)
		_move()


func _move()->void:
	_moves += 1
	if _moves > MAX_MOVES:
		_sprite.play("Demise")
		_dead = true
	else:
		var index := randi()%4
		var next_position = position + NEXT_DIRECTION[index] as Vector2
		while next_position.x < 0 or next_position.x > 288 or next_position.y < 0 or next_position.y > 288:
			index = randi()%4
			next_position = position + NEXT_DIRECTION[index]
		rotation = ANGLE[index]
		_tween.interpolate_property(self, "position", null, next_position, 1.0, Tween.TRANS_QUAD)
		_tween.start()


func _on_AnimatedSprite_animation_finished()->void:
	if _sprite.animation == "Demise":
		queue_free()
