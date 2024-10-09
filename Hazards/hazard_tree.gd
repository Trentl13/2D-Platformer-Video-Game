extends CharacterBody2D

var death_timer: Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_detected_body_entered(body):
	if body.name == "Player":
		get_node("AnimatedSprite2D").play("activate")


func _on_player_kill_body_entered(body):
	if body.name == "Player":
		Game.playerCurrentHP -= 10

