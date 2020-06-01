class_name Bullet
extends Node2D

onready var Destructible = load("res://scripts/Destructible.gd")
onready var Player = load("res://scripts/Player.gd")

export (int) var speed = 600

export (Vector2) var direction = Vector2.RIGHT
export (bool) var is_enemy = false

var velocity = Vector2.ZERO

func _process(delta: float) -> void:
	velocity.x = speed * delta 
	position += velocity * direction
	
	if direction == Vector2.LEFT:
		$Sprite.flip_v = true


func _on_Area2D_body_entered(body: Node) -> void:
	if body.has_node("Destructible") and !is_enemy:
		body.get_node("Destructible").destroy()
		queue_free()
	elif body is Player and is_enemy:
		body.reload()
		queue_free()
		

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
