extends Node2D

class_name Destructible

func destroy():
	if get_owner().has_method("hit"):
		get_owner().hit()
	else:
		get_owner().queue_free()
