extends Node2D

func draw_text(text : String) -> void:
	for letter in text:
	
		modulate = Color.red
		
		var texture = load("res://assets/letters/"+letter+".png")
		var letter_sprite = LetterSprite.new(texture)
		
		add_child(letter_sprite)
	
		letter_sprite.scale = Vector2.ONE * 5
		letter_sprite.position += Vector2.RIGHT * (52 * get_child_count())


func _on_Boss_clear_text() -> void:
	
	for child in get_children():
		child.queue_free()
