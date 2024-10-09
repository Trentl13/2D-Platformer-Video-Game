extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed = 400
var is_moving_down = false
var target_position: Vector2
func _ready():
	pass


func _process(delta):
	position = $".".global_position
	if(is_moving_down):
		position = position.move_toward(target_position, speed * delta)



func _on_player_detected_body_entered(body):
	if body.name == "Player":
		is_moving_down= true
		target_position = position + Vector2(0, 1000)
