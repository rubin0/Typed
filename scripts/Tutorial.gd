extends Node2D
tool
export(String, MULTILINE) var text : String = "PROVA PROVA"

func _ready() -> void:
	var splitted_text = text.to_upper().split("\n")
	
	
	var offset_y : int = 0
	var offset_x : int = 48
	
	var is_colored = false

	for row in splitted_text:
		var i = 0
		
		row = row.strip_edges()
		
		for letter in row:
			if letter != " ":
				if letter == "*":
					is_colored = !is_colored
					continue
					
				if letter == "?":
					letter = "question"
				
				var texture = load("res://assets/letters/" + letter + ".png")
				var letter_sprite = LetterSprite.new(texture)
				
				add_child(letter_sprite)
				
				if is_colored:
					letter_sprite.modulate = Color.green
				
				letter_sprite.scale = Vector2.ONE * 5
				letter_sprite.position += Vector2.RIGHT * (offset_x * i)
				letter_sprite.position += Vector2.DOWN * offset_y
			
			i += 1
			
		offset_y += 64
			
		
func _on_TriggerBack_body_entered(body: Node) -> void:
	if body is Player:
		show()


func _on_Boss_start_battle() -> void:
	yield(get_tree().create_timer(2.0), "timeout")
	self_modulate = self_modulate.linear_interpolate(Color.transparent, 2)
