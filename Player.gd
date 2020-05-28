extends KinematicBody2D

class_name Player

signal changed_text
signal submit_text


export (int) var speed = 400
export (int) var run_speed = 800
export (int) var back_speed = -200
export (int) var increment = 200
export (int) var jump_speed = -900
export (int) var gravity = 1500
export (float) var max_timeout = 1.5

onready var bullet = preload("res://Bullet.tscn")

onready var initial_speed = speed

var velocity = Vector2.ZERO
var snap_normal = Vector2.DOWN

var action : String
var text : String

var double_jump : = false
var can_input : = true
var is_walking : = false
var is_ducking : = false

var can_jump : = true

var state = "IDLE"

func _ready() -> void:
	$AnimatedSprite.play("idle")
	
	if SaveState.exist_save():
		global_position = SaveState.get_save_position()


func _input(event : InputEvent):
	if !can_input:
		return
		
	if event is InputEventMouseButton:
		return
	if event is InputEventWithModifiers and event.is_pressed():
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
			
		
func submit(text : String) -> bool:
	match text:
		"WALK", "JUMP", "FAST", "SLOW", "FIRE", "STOP", "DUCK", "BACK", "RUN", "J" :
			action = text
		_ :
			return false
	
	return true

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		double_jump = false
		can_jump = true
	
	if state == "JUMP" and is_on_floor():
		state = "WALK"
		
	if velocity.x == 0 and state != "DUCK":
		state = "IDLE"
	
	match action:
		"JUMP" :
			if can_jump:
				snap_normal = Vector2.ZERO
				can_jump = false
				double_jump = true
				$AnimatedSprite.play("jump")
				velocity.y = jump_speed
				state = "JUMP"
		"J" :
			if !is_on_floor() and double_jump:
				$AnimatedSprite.play("jump")
				velocity.y = jump_speed
				double_jump = false
				state = "JUMP"
		"WALK" :
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
			var bullet_instance = bullet.instance()
			$Position2D.add_child(bullet_instance)
		"DUCK" :
			velocity.x = 0
			state = "DUCK"
			$AnimatedSprite.offset = Vector2(0, 45)
			$AnimatedSprite.scale = Vector2(1, 0.65)
			$CollisionShape2D.disabled = true
			$CollisionShapeDuck.disabled = false
		"BACK" :
			velocity.x = back_speed
			state = "BACK"
			$AnimatedSprite.play("walk", true)
	
	if state == "WALK":
		velocity.x = speed
		$AnimatedSprite.play("walk")
		
	if state == "DUCK":
		$AnimatedSprite.play("duck")
				
	if state == "IDLE":
		speed = initial_speed
		$AnimatedSprite.play("idle")
		
	if state != "DUCK":
		$AnimatedSprite.offset = Vector2(0, 0)
		$AnimatedSprite.scale = Vector2(1, 1)
		$CollisionShape2D.disabled = false
		$CollisionShapeDuck.disabled = true
	
	action = ""

func walk():
	state = "WALK"


func _on_TextWriter_timeout() -> void:
	text = ""


func _on_TextWriter_can_input() -> void:
	can_input = true


func _on_VisibilityNotifier2D_screen_exited() -> void:
	reload()
	
func reload() -> void:
	get_tree().reload_current_scene()
	
func save(position : Vector2):
	SaveState.save(position)
