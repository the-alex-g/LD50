class_name RingDictionary
extends Node

const FULL := "full"
const EMPTY := "empty"

var _dictionary := {}


func generate(side_length:int, offset:int)->void:
	for x in side_length:
		_dictionary[Vector2(x, 0) + Vector2(offset, offset)] = EMPTY
		_dictionary[Vector2(x, side_length - 1) + Vector2(offset, offset)] = EMPTY
		_dictionary[Vector2(0, x) + Vector2(offset, offset)] = EMPTY
		_dictionary[Vector2(side_length - 1, x) + Vector2(offset, offset)] = EMPTY
	_dictionary[Vector2(side_length, side_length)] = EMPTY


func is_not_full()->bool:
	for key in _dictionary:
		if _dictionary[key] == EMPTY:
			return true
	return false


func fill(key:Vector2)->void:
	_dictionary[key] = FULL


func empty(key:Vector2)->void:
	_dictionary[key] = EMPTY


func get_empty_keys()->Array:
	var keys := []
	for key in _dictionary:
		if _dictionary[key] == EMPTY:
			keys.append(key)
	return keys


func get_keys()->Array:
	return _dictionary.keys()
