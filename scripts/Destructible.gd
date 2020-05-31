extends Node2D

class_name Destructible

func destroy():
	get_owner().queue_free()
