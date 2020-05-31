extends Area2D

signal triggered

onready var spawn_position : Position2D = $SpawnPosition
export(String) var object_to_spawn_path

var object_to_spawn : Resource

func _ready() -> void:
	object_to_spawn = load(object_to_spawn_path)

func _on_SpawnTrigger_body_entered(body: Node) -> void:
	if body is Player:
		var object = object_to_spawn.instance()
		emit_signal("triggered", spawn_position.global_position, object)
