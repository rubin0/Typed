extends KinematicBody2D

signal emit_new_word
signal clear_text
signal killed
signal start_battle

export(bool) var can_be_hit = true
export(int) var bullets_from_above_number = 8
export(float) var attack_delay = 2.5

onready var bullet = preload("res://scenes/Bullet.tscn")
onready var bullets_high = preload("res://scenes/Bullets.tscn")
onready var bullets_low = preload("res://scenes/BulletsLow.tscn")

var attack_timer : Timer

var words = ["RASENGAN", "KAMEHAMEHA", "GOMUGOMUNOPISTOL" , "OMAEWAMOUSHINDERU"]

var word : String
var percentage : float

var hp = 4

func _ready() -> void:
	percentage = 1.0 / words.size()
	set_process(false)
	hp = words.size()


func trigger():
	set_process(true)
	attack_timer  = $Timer
	attack_timer.start(attack_delay)
	$AnimationPlayer.play("idle")
	emit_signal("start_battle")
	yield(get_tree().create_timer(attack_delay), "timeout")
	emit_new_word()
	
func choose_attack():
	var index = randi() % 4
	
	match index:
		0:
			attack_from_above()
		1:
			attack_high()
		2:
			attack_low()
			
	attack_timer.start(attack_delay)

func attack_from_above():
	var position_indexes = []
	
	for i in range(11):
		position_indexes.append(i)
		
	position_indexes.shuffle()
	position_indexes = position_indexes.slice(0, bullets_from_above_number - 1)
	
	var position = $AttackFromAbove
	
	for index in position_indexes:
		var bullet_instance : Bullet = bullet.instance()
		bullet_instance.speed = 300
		bullet_instance.direction = Vector2.DOWN
		bullet_instance.is_enemy = true
		add_child(bullet_instance, true)
	
		bullet_instance.global_position.x = position.global_position.x + (index * 192)
		bullet_instance.global_position.y = position.global_position.y 
		
func attack_high():
	var position = $AttackHigh
	
	var bullet_instance = bullets_high.instance()
	add_child(bullet_instance, true)
	bullet_instance.global_position = position.global_position
	
func attack_low():
	var position = $AttackLow
	
	var bullet_instance = bullets_low.instance()
	add_child(bullet_instance, true)
	bullet_instance.global_position = position.global_position
	

func _on_BossHealth_hit() -> void:
	$Writer._on_Boss_clear_text()
	
	var color : Color = $Sprite.modulate
	color.g = color.g + percentage
	color.b = color.b + percentage
	$Sprite.modulate = Color(color.r, color.g, color.b, color.a)
	
	hp -= 1
	
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("hit")
	
	if hp == 0:
		$Explosion/AnimationPlayer.play("Explode")
		$Timer.stop()
		$AnimationPlayer.play("death")
		return
		
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


func _on_Timer_timeout() -> void:
	choose_attack()
	
func death_anim_ended():
	emit_signal("killed")
	queue_free()
