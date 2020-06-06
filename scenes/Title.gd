extends TileMap

signal draw_text
signal submit_text
signal start_boss

var boss_triggered : = false

onready var bullet = preload("res://scenes/Bullet.tscn")
	
func _ready() -> void:
	$Player.connect("fire", self, "_on_fire")
	
	for node in get_tree().get_nodes_in_group("spawn_trigger"):
		node.connect("triggered", self, "_on_trigger")
		
	$Player/Music.play()
	
func _on_fire(position : Vector2):
	var bullet_instance : Bullet = bullet.instance()
	bullet_instance.direction = Vector2.RIGHT
	bullet_instance.is_enemy = false
	add_child(bullet_instance)
	bullet_instance.global_position = position


func _on_Area2D_entered() -> void:
	$Player.idle()
	$Text.visible = false
	$Text2.visible = false
	$Control/BlackScreen/Tween.interpolate_property($Control/BlackScreen, "modulate:a", 
	0, 1, 1.0, 
	Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	$Control/BlackScreen/Tween.start()
	

func _on_Tween_tween_all_completed() -> void:
	SceneManager.to_game()
