extends Node2D

var letters = []

var offset : int = 5

var timer : float = 3.0

signal timeout
signal timer
signal can_input

onready var initial_timer : float = timer

func _process(delta: float) -> void:
	timer = timer - delta
	
	if timer < 0:
		timeout()
		timer_restart()
	
	emit_signal("timer", timer)
	

func _on_Player_changed_text(text : String) -> void:
	timer_restart()
	
	modulate = Color.white
	
	letters.append(text)
	
	var texture = load("res://assets/letters/"+text+".png")
	var letter_sprite = LetterSprite.new(texture)
	
	add_child(letter_sprite)

	letter_sprite.scale = Vector2.ONE * 5
	letter_sprite.position += Vector2.RIGHT * (52 * get_child_count())
	
	emit_signal("can_input")
	
	
func _on_Player_submit_text(result : bool) -> void:
	timer_restart()
	
	if result:
		modulate = Color.green
	else:
		modulate = Color.red
		
	yield(get_tree().create_timer(0.1), "timeout")
	
	letters.clear()
	for child in get_children():
		child.queue_free()
		
	emit_signal("can_input")
		
func timeout() -> void:
	modulate = Color.black
	
	emit_signal("timeout")
	
	letters.clear()
	for child in get_children():
		child.queue_free()
	
	timer_restart()
	
func timer_restart() -> void:
	timer = initial_timer


func _on_Player_cancel_text() -> void:
	timeout()
