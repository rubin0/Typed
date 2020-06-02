extends Node2D
tool
export var amount : float = 0

func _ready() -> void:
	$KinematicBody2D.global_position = $Start.global_position


func _on_Area2D_body_entered(body: Node) -> void:
	print(body.name)
	if body is Player:
		yield(get_tree().create_timer(1.0), "timeout")
		print("moving")
		$AnimationPlayer.play("moving")
		
		
func _process(delta: float) -> void:
	$KinematicBody2D.global_position = $Start.global_position.linear_interpolate($End.global_position, amount)
