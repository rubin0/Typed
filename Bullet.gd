extends Node2D

export (int) var speed = 400
export (int) var gravity = 1200

var velocity = Vector2.ZERO

func _process(delta: float) -> void:
	velocity.x = speed * delta
	position += velocity


func _on_Area2D_body_entered(body: Node) -> void:
	if body and body.is_in_group("enemy"):
		queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
