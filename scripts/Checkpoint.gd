class_name CheckPoint
extends Sprite

onready var Player = load("res://scripts/Player.gd")


func _on_Trigger_body_entered(body: Node) -> void:
	if body is Player:
		$AudioStreamPlayer.play()
		body.save(self.global_position + (Vector2.RIGHT * 75))
		modulate = Color.green
		$Trigger.queue_free()
