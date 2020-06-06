extends Node

func to_title():
	get_tree().change_scene("res://scenes/Title.tscn")
	
func to_game():
	get_tree().change_scene("res://scenes/Game.tscn")
