extends TileMap

signal draw_text
signal submit_text


func _ready() -> void:
	$Player.connect("changed_text", self, "_on_change_text")
	$Player.connect("submit_text", self, "_on_submit_text")
	
func _on_change_text(text : String):
	emit_signal("draw_text", text)
	
func _on_submit_text(result : bool):
	emit_signal("submit_text", result)
