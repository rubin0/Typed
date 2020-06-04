extends Node2D

signal hit

func hit():
	emit_signal("hit")
	
func destroy():
	get_owner().queue_free()
