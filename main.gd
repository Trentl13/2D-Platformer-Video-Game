extends Node2D


func _ready():
	#Utils.saveGame()
	#Utils.loadGame()
	pass

func _on_izlez_pressed():
	get_tree().quit() 


func _on_vlez_pressed():
	get_tree().change_scene_to_file("res://World.tscn") 
