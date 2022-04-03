extends Node2D

signal game_over

const PLANT_TIME_STEP := 1.01

export var _plant_time := 1.0
export var _load_time := 3.0

var _1_spaces := RingDictionary.new()
var _2_spaces := RingDictionary.new()
var _3_spaces := RingDictionary.new()
var _4_spaces := RingDictionary.new()
var _plants_poisoned := 0
var _game_over := false
var _loaded := true

onready var _tilemap = $TileMap as TileMap
onready var _plant_timer = $PlantAdvanceTimer as Timer
onready var _load_timer = $LoadTimer as Timer
onready var _cursor_manager = $CursorManager as CursorManager
onready var _hud = $HUD


func _ready()->void:
	randomize()
	for x in 4:
		var list_name := "_" + str(x + 1) + "_spaces"
		get(list_name).generate(9 - x * 2, x)
	_cursor_manager.update_anim_time(_load_time)


func _input(event:InputEvent)->void:
	if event is InputEventMouseButton:
		if _loaded:
			var mouse_position := get_global_mouse_position()
			var map_mouse_position = _tilemap.world_to_map(mouse_position) as Vector2
			if _tilemap.get_cellv(map_mouse_position) != -1:
				_loaded = false
				_load_timer.start(_load_time)
				_tilemap.set_cellv(map_mouse_position, -1)
				_plants_poisoned += 1
				_hud.update_repute(_plants_poisoned)
				_cursor_manager.empty()
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
			var plant_position = empty_positions[randi() % empty_positions.size()] as Vector2
			get(ring_name).fill(plant_position)
			
			_tilemap.set_cellv(plant_position, 0)
			
			running = false
		
		else:
			if ring_index < 4:
				ring_index += 1
			elif ring_index == 4:
				emit_signal("game_over")
				running = false


func _on_LoadTimer_timeout()->void:
	_loaded = true


func _on_Main_game_over()->void:
	_game_over = true
