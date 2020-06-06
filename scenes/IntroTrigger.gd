extends Area2D

signal entered


func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		emit_signal("entered")
