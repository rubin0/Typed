extends Control


func _on_VideoPlayer_finished() -> void:
	$BlackScreen/Tween.interpolate_property($BlackScreen, "modulate:a", 
	0, 1, 1.0, 
	Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	$BlackScreen/Tween.start()

func _on_Tween_tween_all_completed() -> void:
	SceneManager.to_title()
