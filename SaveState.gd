extends Node


var save_position : Vector2 = Vector2.ZERO

func save(position : Vector2):
	save_position = position
	
func exist_save():
	return save_position.length() > 0
	
func get_save_position() -> Vector2:
	return save_position
