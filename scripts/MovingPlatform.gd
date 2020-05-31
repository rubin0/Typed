extends Node2D


func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		yield(get_tree().create_timer(1.0), "timeout")
		$AnimationPlayer.play("PathFollow")
