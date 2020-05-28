extends Node2D

export (int) var speed = 400
export (int) var gravity = 1200

export (Vector2) var direction = Vector2.RIGHT
export (bool) var is_enemy = false

var velocity = Vector2.ZERO

func _process(delta: float) -> void:
	velocity.x = speed * delta 
	position += velocity * direction
	
	if direction == Vector2.LEFT:
		$Sprite.flip_v = true


func _on_Area2D_body_entered(body: Node) -> void:
	if body is Destructible and !is_enemy:
		body.destroy()
	elif body.is_in_group("player") and is_enemy:
		body.reload()
		

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
