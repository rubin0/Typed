extends KinematicBody2D

signal emit_new_word
signal clear_text

export(int) var hp = 4
export(bool) var can_be_hit = true

var words = ["MUORIBRUTTOCICCIONE", "SGORBIOZ", "CIAOOOO", "LOLOLOXD", "MUORIBRUTTOCICCIONE"]

var word : String
var percentage : float

func _ready() -> void:
	percentage = 1.0 / words.size()
	set_process(false)


func trigger():
	set_process(true)
	emit_new_word()
	

func _on_BossHealth_hit() -> void:
	$Writer._on_Boss_clear_text()
	
	var color : Color = $Sprite.modulate
	color.g = color.g + percentage
	color.b = color.b + percentage
	$Sprite.modulate = Color(color.r, color.g, color.b, color.a)
	
	hp -= 1
	
	if hp == 0:
		queue_free()
		
	yield(get_tree().create_timer(2.0), "timeout")
	
	emit_new_word()
		
		
func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		body.reload()
		

func emit_new_word():
	$Writer._on_Boss_clear_text()
	
	word = words.pop_front()
	
	$Writer.draw_text(word)
	
	emit_signal("emit_new_word", word)


func _on_Player_wrote_boss_word() -> void:
	_on_BossHealth_hit()
