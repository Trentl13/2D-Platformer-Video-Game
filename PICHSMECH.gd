extends CharacterBody2D


var SPEED = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player 
var chase = false
var knockback_dir = Vector2.ZERO

@onready var collision_shapes = [$PlayerCollision/Detection]
func _ready():
	get_node("AnimatedSprite2D").play("idle")
func _physics_process(delta):
	velocity.y += gravity * delta
	if chase == true:
		if get_node("AnimatedSprite2D").animation != "death":
			get_node("AnimatedSprite2D").play("jump")
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		if direction.x> 0:
			get_node("AnimatedSprite2D").flip_h = true
			flip_collision_shapes(false)
		elif direction.x <= 0:
			get_node("AnimatedSprite2D").flip_h = false
			flip_collision_shapes(true)
		knockback_dir = direction
		velocity.x = direction.x*SPEED
	else:
		if get_node("AnimatedSprite2D").animation != "death":
			get_node("AnimatedSprite2D").play("idle")
		velocity.x = 0
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


func _on_player_collision_body_entered(body):
	pass

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

func flip_collision_shapes(flip_h):
	for shape in collision_shapes:
		var shape_position=shape.position
		if flip_h:
			shape_position.x = -abs(shape_position.x)
		else:
			shape_position.x = abs(shape_position.x)
		shape.position = shape_position
