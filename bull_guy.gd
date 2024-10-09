extends CharacterBody2D

var SPEED = 2000
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player 
var chase = false
var initial_direction = Vector2.ZERO
var knockback_dir = Vector2.ZERO

@onready var collision_shapes = [$PlayerPush/CollisionShape2D]
func _ready():
	get_node("AnimatedSprite2D").play("rush")
	get_node("AnimatedSprite2D").flip_h = true

func _physics_process(delta):
	velocity.y += gravity * delta
	if chase == true:
		if get_node("AnimatedSprite2D").animation != "death":
			get_node("AnimatedSprite2D").play("rush")
		player = get_node("../../Player/Player")
		if initial_direction == Vector2.ZERO:
			initial_direction = (player.position -self.position).normalized()
			velocity.x = initial_direction.x*SPEED
		if is_on_wall():
			velocity.x = initial_direction.x*SPEED
	else:
		if get_node("AnimatedSprite2D").animation != "death":
			get_node("AnimatedSprite2D").play("rush")
		velocity.x = initial_direction.x*SPEED
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_player_death_body_entered(body):
	if body.name == "Player":
		death()
		
func death():
	Game.Score += 1
	#Utils.saveGame()
	chase = false
	get_node("AnimatedSprite2D").play("death")
	queue_free_after_animation()
	
func disable_collisions():
	for shape in get_children():
		if shape is CollisionShape2D:
			shape.disabled = true
func queue_free_after_animation():
	call_deferred("disable_collisions")
	await get_node("AnimatedSprite2D").animation_finished
	queue_free()


func _on_player_collision_body_entered(body):
	if body.name == "Player":
		pass

#func is_colliding_with_player() -> bool:
	#return player.position.distance_to(position) < 23.1


