extends Camera2D

func trigger(camera_pos : Vector2):

	$Tween.interpolate_property(self, "global_position",
			global_position, camera_pos, 2.5,
			Tween.TRANS_QUAD, Tween.EASE_IN, .2)
					
	$Tween.start()
	
