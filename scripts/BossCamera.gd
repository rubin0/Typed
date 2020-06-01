extends Camera2D


func trigger():
	pass
	#current = true


func _on_Tween_tween_all_completed() -> void:
	$InvisibleWall/CollisionShape2D.disabled = false
	current = true
