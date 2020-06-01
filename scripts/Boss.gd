extends KinematicBody2D


func _ready() -> void:
	set_process(false)

func trigger():
	set_process(true)
