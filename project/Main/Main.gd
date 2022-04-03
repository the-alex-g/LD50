extends Node2D

const PLANT_TIME_STEP := 1.1

var _1_spaces := []
var _2_spaces := []
var _3_spaces := []
var _4_spaces := []
var _plant_time := 2.0
var _game_over := false

onready var _tilemap = $TileMap as TileMap
onready var _plant_timer = $PlantAdvanceTimer as Timer


func _ready()->void:
	randomize()
	for x in 4: # 0-3
		set("_" + str(x + 1) + "_spaces", _generate_spaces(9 - x * 2, x))


func _generate_spaces(side_length:int, offset:int)->Array:
	var array := []
	
	for x in side_length:
		if not array.has(Vector2(x, 0) + Vector2(offset, offset)):
			array.append(Vector2(x, 0) + Vector2(offset, offset))
		if not array.has(Vector2(x, side_length - 1) + Vector2(offset, offset)):
			array.append(Vector2(x, side_length - 1) + Vector2(offset, offset))
		if not array.has(Vector2(0, x) + Vector2(offset, offset)):
			array.append(Vector2(0, x) + Vector2(offset, offset))
		if not array.has(Vector2(side_length - 1, x) + Vector2(offset, offset)):
			array.append(Vector2(side_length - 1, x) + Vector2(offset, offset))
	if not array.has(Vector2(side_length, side_length)):
		array.append(Vector2(side_length, side_length))
	
	return array



func _on_PlantAdvanceTimer_timeout()->void:
	if _game_over:
		return
	_add_plant()
	_plant_time /= PLANT_TIME_STEP
	_plant_timer.start(_plant_time)


func _add_plant()->void:
	var ring_index := 1
	var running := true
	while running:
		var ring_name := "_" + str(ring_index) + "_spaces"
		var ring = get(ring_name) as Array
	
		if ring.size() > 0:
			var plant_position = ring[randi() % ring.size()] as Vector2
		
			while _tilemap.get_cellv(plant_position) != -1:
				plant_position = ring[randi() % ring.size()]
			
			ring.erase(plant_position)
			set(ring_name, ring)
			print(get(ring_name).size())
			
			_tilemap.set_cellv(plant_position, 0)
			
			running = false

		else:
			if ring_index < 4:
				ring_index += 1
				print("proceed")
			else:
				_game_over = true
				running = false
