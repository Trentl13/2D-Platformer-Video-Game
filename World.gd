extends Node2D




func _on_fall_zone_body_entered(body):
	if body.name == "Player":
		Game.playerCurrentHP = 10
		Game.Score = 0
		get_tree().change_scene_to_file("res://main.tscn")
