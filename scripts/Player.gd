extends KinematicBody2D

class_name Player

signal changed_text
signal submit_text
signal fire
signal cancel_text
signal wrote_boss_word

export (int) var speed = 400
export (int) var run_speed = 800
export (int) var back_speed = -200
export (int) var increment = 200
export (int) var jump_speed = -900
export (int) var gravity = 1500
export (int) var title_gravity = 25000
export (float) var max_timeout = 1.5

onready var initial_speed = speed

var velocity = Vector2.ZERO
var snap_normal = Vector2.DOWN

var action : String
var text : String

var double_jump : = false
var can_input : = true
var is_walking : = false
var is_ducking : = false
var is_falling : = false

var can_jump : = true

var state = "IDLE"

var boss_word : String = "ROBE"

func _ready() -> void:
	$AnimatedSprite.play("idle")
	
	$Music.play()
	
	if SaveState.exist_save():
		global_position = SaveState.get_save_position()


func _input(event : InputEvent):
	if !can_input:
		return

	if event is InputEventKey and event.is_pressed():
		if event.scancode and event.scancode == KEY_ENTER:
			var result : bool = submit(text.to_upper())
			text = ""
			can_input = false
			emit_signal("submit_text", result)
		else:
			if event.scancode >= 65 and event.scancode <= 90:
				can_input = false
				text += event.as_text()
				emit_signal("changed_text", event.as_text())
			
		
func submit(command : String) -> bool:
	match command:
		"WALK", "JUMP", "FAST", "SLOW", "FIRE", "STOP", "DUCK", "BACK", "RUN", "J", "START", boss_word :
			action = command
		_ :
			return false
	
	return true
	
func delete_text():
	emit_signal("cancel_text")

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if is_falling:
		velocity.y = gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		double_jump = false
		can_jump = true
	
	if state == "JUMP" and is_on_floor():
		walk()
		
	if velocity.x == 0 and state != "DUCK":
		state = "IDLE"
		$AnimationPlayer.play("idle")
	
	match action:
		"JUMP" :
			if can_jump:
				snap_normal = Vector2.ZERO
				can_jump = false
				double_jump = true
				$AnimatedSprite.play("jump")
				velocity.y = jump_speed
				state = "JUMP"
				$JumpSound.play()
				$AnimationPlayer.play("jump")
		"J" :
			if !is_on_floor() and double_jump:
				$AnimatedSprite.play("jump")
				velocity.y = jump_speed
				double_jump = false
				state = "JUMP"
				$JumpSound.play()
				$AnimationPlayer.play("jump2")
		"WALK" :
			walk()
		"START" :
			walk()
		"RUN" :
			walk()
			speed = run_speed
		"SLOW" :
			speed = max(100, speed - increment)
		"FAST" :
			speed = min(1000, speed + increment)
		"STOP" :
			velocity.x = 0
			state = "IDLE"
		"FIRE" :
			emit_signal("fire", $Position2D.global_position)
			$ShootSound.play()
		"DUCK" :
			velocity.x = 0
			state = "DUCK"
			$AnimatedSprite.offset = Vector2(0, 45)
			$AnimatedSprite.scale = Vector2(1, 0.65)
			$CollisionShape2D.disabled = true
			$CollisionShapeDuck.disabled = false
			$DuckSound.play()
		"BACK" :
			velocity.x = back_speed
			state = "BACK"
			$AnimatedSprite.play("walk", true)
		boss_word :
			emit_signal("wrote_boss_word")
			$Camera2D.add_trauma(1)
			action = "IDLE"
	
	if state == "WALK":
		velocity.x = speed
		$AnimatedSprite.play("walk")
		
	if state == "DUCK":
		$AnimatedSprite.play("duck")
				
	if state == "IDLE":
		speed = initial_speed
		$AnimatedSprite.play("idle")
		$AnimationPlayer.play("idle")
		
	if state != "DUCK":
		$AnimatedSprite.offset = Vector2(0, 0)
		$AnimatedSprite.scale = Vector2(1, 1)
		$CollisionShape2D.disabled = false
		$CollisionShapeDuck.disabled = true
	
	action = ""

func walk():
	state = "WALK"
	$AnimationPlayer.play("walk")


func _on_TextWriter_timeout() -> void:
	text = ""


func _on_TextWriter_can_input() -> void:
	can_input = true


func _on_VisibilityNotifier2D_screen_exited() -> void:
	reload()
	
func reload():
	return get_tree().reload_current_scene()
	
func save(position : Vector2):
	SaveState.save(position)
	
func trigger_boss_fight():
	can_input = false
	velocity.x = 0
	state = "IDLE"
	delete_text()
	$BossBattle.play()
	$Music.stop()
	
func idle():
	can_input = false
	velocity.x = 0
	state = "IDLE"
	delete_text()
	$Music.stop()
	$AnimatedSprite.visible = false
	
func start_boss_fight():
	can_input = true


func _on_Boss_emit_new_word(word : String) -> void:
	boss_word = word


func _on_Boss_killed() -> void:
	$VisibilityNotifier2D.disconnect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
	$CameraTitles.current = true
	
	$BossBattle.stop()
	$Music.play()

func _on_GravityTrigger_body_entered(body: Node) -> void:
	if body and body.is_in_group("player"):
		gravity = title_gravity
		is_falling = true
