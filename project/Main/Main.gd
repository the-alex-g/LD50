extends Node2D

var _1_spaces := []
var _2_spaces := []
var _3_spaces := []
var _4_spaces := []
var _5_spaces := []
var _6_spaces := []
var _7_spaces := []
var _8_spaces := []

onready var _tilemap = $TileMap as TileMap


func _ready()->void:
	for x in 4: # 0-3
		set("_" + str(x + 1) + "_spaces", _generate_spaces(9 - x * 2, x))


func _generate_spaces(side_length, offset)->Array:
	var array := []
	
	for x in side_length:
		array.append(Vector2(x, 0) + Vector2(offset, offset))
		array.append(Vector2(x, side_length - 1) + Vector2(offset, offset))
		array.append(Vector2(0, x) + Vector2(offset, offset))
		array.append(Vector2(side_length - 1, x) + Vector2(offset, offset))
	array.append(Vector2(side_length, side_length))
	
	return array

