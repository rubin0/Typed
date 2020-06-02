extends Camera2D

signal cutscene_completed


func trigger():
	pass
	#current = true


func _on_Tween_tween_all_completed() -> void:
	$InvisibleWall/CollisionShape2D.disabled = false
	current = true
	emit_signal("cutscene_completed")
