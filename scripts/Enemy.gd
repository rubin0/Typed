class_name Enemy

extends KinematicBody2D

export (int) var speed = 400
export (int) var gravity = 1500

var direction = Vector2.RIGHT
var velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity.x = speed * direction.x
	velocity.y += gravity * delta
	
	move_and_slide(velocity, Vector2.UP)
	
	if is_on_wall() or !$Pivot/RayCast2D.is_colliding():
		direction.x = -direction.x 
		$Pivot.scale.x = -$Pivot.scale.x
