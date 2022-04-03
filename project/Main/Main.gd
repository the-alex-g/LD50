extends Node2D

signal game_over

const PLANT_TIME_STEP := 1.01
const REFILL_TIME_STEP := 1.5
const EMPTY := 1
const INITIAL_TILES := 2

export var _plant_time := 1.0
export var _load_time := 3.0

var _1_spaces := RingDictionary.new()
var _2_spaces := RingDictionary.new()
var _3_spaces := RingDictionary.new()
var _4_spaces := RingDictionary.new()
var _game_over := false
var _loaded := true
var _plants_added := 0

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
			_check_for_plant(map_mouse_position)


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
			
			_plants_added += 1
			var tile_index = _plants_added + INITIAL_TILES
			_tilemap.tile_set.create_tile(tile_index)
			_tilemap.tile_set.tile_set_texture(tile_index, _create_texture())
			_tilemap.set_cellv(plant_position, tile_index)
			
			running = false
		
		else:
			if ring_index < 4:
				ring_index += 1
			elif ring_index == 4:
				emit_signal("game_over")
				running = false


func _on_LoadTimer_timeout()->void:
	_loaded = true


func _remove_tile(tile_position:Vector2)->void:
	_tilemap.set_cellv(tile_position, EMPTY)
	_hud.increment_repute()
	_cursor_manager.empty()
	for x in 4:
		var ring_name := "_" + str(x + 1) + "_spaces"
		var keys = get(ring_name).get_keys() as Array
		if keys.has(tile_position):
			get(ring_name).empty(tile_position)
			break


func _check_for_loose_tiles(tile_position:Vector2)->void:
	var left_side := tile_position + Vector2.LEFT
	var right_side := tile_position + Vector2.RIGHT
	var top := tile_position + Vector2.UP
	var bottom := tile_position + Vector2.DOWN
	_evaluate_potentially_loose_tile(left_side, true)
	_evaluate_potentially_loose_tile(right_side, true)
	_evaluate_potentially_loose_tile(top)
	_evaluate_potentially_loose_tile(bottom)


func _evaluate_potentially_loose_tile(tile_position:Vector2, vertical_check := false)->void:
	var first_position := tile_position + (Vector2.UP if vertical_check else Vector2.LEFT)
	var second_position := tile_position + (Vector2.DOWN if vertical_check else Vector2.RIGHT)
	if _tilemap.get_cellv(tile_position) != EMPTY and tile_position.x != 8 and tile_position.x != 0 and tile_position.y != 8 and tile_position.y != 0:
		if _tilemap.get_cellv(first_position) == EMPTY and _tilemap.get_cellv(second_position) == EMPTY:
			_remove_tile(tile_position)


func _on_Main_game_over()->void:
	_game_over = true


func _on_HUD_reduce_refill_time()->void:
	if _load_time >= 1.0:
		_load_time /= REFILL_TIME_STEP
		_cursor_manager.update_anim_time(_load_time)


func _create_texture()->AnimatedTexture:
	var texture := AnimatedTexture.new()
	texture.frames = 7
	for x in 7:
		texture.set_frame_texture(x, load("res://Main/PlantImages/tile_" + str(x) + ".png"))
	texture.oneshot = true
	return texture


func _on_HUD_spawn_agent()->void:
	var agent = load("res://Agent/Agent.tscn").instance() as Node2D
	agent.position = Vector2(144, 144)
	agent.connect("probe", self, "_on_agent_probe")
	add_child(agent)


func _on_agent_probe(agent_position:Vector2)->void:
	var position_on_map = _tilemap.world_to_map(agent_position) as Vector2
	_check_for_plant(position_on_map)


func _check_for_plant(map_position:Vector2)->void:
	if _tilemap.get_cellv(map_position) >= INITIAL_TILES:
		_loaded = false
		_load_timer.start(_load_time)
		_remove_tile(map_position)
		_check_for_loose_tiles(map_position)
