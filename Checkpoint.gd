extends Sprite

class_name CheckPoint


func _on_Trigger_body_entered(body: Node) -> void:
	if body is Player:
		body.save(self.global_position + (Vector2.RIGHT * 75))
		modulate = Color.green
		$Trigger.queue_free()
