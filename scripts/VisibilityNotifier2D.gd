extends VisibilityNotifier2D


func _on_Boss_boss_killed() -> void:
	queue_free()
