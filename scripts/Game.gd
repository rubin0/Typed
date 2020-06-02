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
	
func _on_fire(position : Vector2):
	var bullet_instance : Bullet = bullet.instance()
	bullet_instance.direction = Vector2.RIGHT
	bullet_instance.is_enemy = false
	add_child(bullet_instance)
	bullet_instance.global_position = position
	
func _on_trigger(spawn_position : Vector2, object_to_spawn):
	object_to_spawn.global_position = spawn_position
	call_deferred("add_child", object_to_spawn)
	
func _on_BossTrigger_body_exited(body: Node) -> void:
	if body is Player and !boss_triggered:
		boss_triggered = true
		$BossCamera.trigger()
		$Player/Camera2D.trigger($BossCamera.global_position)
		$Player.trigger_boss_fight()


func _on_BossCamera_cutscene_completed() -> void:
	$Enemies/Boss.trigger()
	$Player.start_boss_fight()
