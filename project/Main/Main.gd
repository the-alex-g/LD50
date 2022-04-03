extends Node2D

const PLANT_TIME_STEP := 1.1

export var _plant_time := 1.0

var _1_spaces := RingDictionary.new()
var _2_spaces := RingDictionary.new()
var _3_spaces := RingDictionary.new()
var _4_spaces := RingDictionary.new()
var _game_over := false
var _loaded := true

onready var _tilemap = $TileMap as TileMap
onready var _plant_timer = $PlantAdvanceTimer as Timer


func _ready()->void:
	randomize()
	for x in 4: # 0-3
		var list_name := "_" + str(x + 1) + "_spaces"
		get(list_name).generate(9 - x * 2, x)


func _input(event:InputEvent)->void:
	if event is InputEventMouseButton:
		if _loaded:
			var mouse_position := get_global_mouse_position()
			var map_mouse_position = _tilemap.world_to_map(mouse_position) as Vector2
			if _tilemap.get_cellv(map_mouse_position) != -1:
				#_loaded = false
				_tilemap.set_cellv(map_mouse_position, -1)
				for x in 4:
					var ring_name := "_" + str(x + 1) + "_spaces"
					var keys = get(ring_name).get_keys() as Array
					if keys.has(map_mouse_position):
						get(ring_name).empty(map_mouse_position)
						break



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
		
	
		if get(ring_name).is_not_full():
			var empty_positions = get(ring_name).get_empty_keys() as Array
			print(empty_positions.size())
			var plant_position = empty_positions[randi() % empty_positions.size()] as Vector2
			get(ring_name).fill(plant_position)
			
			_tilemap.set_cellv(plant_position, 0)
			
			running = false

		else:
			if ring_index < 4:
				ring_index += 1
			elif ring_index == 4:
				_game_over = true
				running = false
				print("over")
