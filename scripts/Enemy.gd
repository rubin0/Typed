class_name Enemy

signal hit

extends KinematicBody2D

export (int) var speed = 400
export (int) var gravity = 1500

var direction = Vector2.RIGHT
var velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity.x = speed * direction.x
	velocity.y += gravity * delta
	
	move_and_slide(velocity, Vector2.UP)
	
	if !$Pivot/RayCast2D.is_colliding() or is_on_wall():
		direction.x = -direction.x 
		$Pivot.scale.x = -$Pivot.scale.x


func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		body.reload()
		
func hit():
	get_parent().play_hit_sound()
	queue_free()
