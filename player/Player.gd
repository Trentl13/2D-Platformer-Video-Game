extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var knockback_timer : Timer
var is_knockback_active: bool = false
var receives_knockback: bool = false
const knockback_duration = 0.3
const knockback_strength = 300
var input_locked: bool = false
var death_timer : Timer
var is_dead : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation = get_node("AnimationPlayer")
func _ready():
	
	get_node("AnimatedSprite2D").play("idle")
	knockback_timer = Timer.new()
	knockback_timer.wait_time = knockback_duration
	knockback_timer.one_shot = true
	knockback_timer.connect("timeout",Callable(self, "_on_knockback_timeout"))
	add_child(knockback_timer)
	
	death_timer = Timer.new()
	death_timer.wait_time = 1.5
	death_timer.one_shot = true
	death_timer.connect("timeout",Callable(self, "on_death_timeout"))
	add_child(death_timer)

func _physics_process(delta):
	if input_locked and is_knockback_active:
		pass
	else:
	
	# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

	# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor() and is_dead == false:
			velocity.y = JUMP_VELOCITY
			if get_node("AnimatedSprite2D").animation != "hurt":
				animation.play("jump")


		var direction = Input.get_axis("ui_left", "ui_right")
		if direction == -1:
			get_node("AnimatedSprite2D").flip_h = true
			if get_node("AnimatedSprite2D").animation == "hurt":
				get_node("AnimatedSprite2D").flip_h = false
		elif (direction == 1):
			get_node("AnimatedSprite2D").flip_h = false
		if (direction and is_knockback_active == false and receives_knockback == false and is_dead == false):
			velocity.x = direction * SPEED
			if(velocity.y == 0):
				if get_node("AnimatedSprite2D").animation != "hurt":
					animation.play("run")
		else:
			if(velocity.y == 0):
				if get_node("AnimatedSprite2D").animation != "death":
					if get_node("AnimatedSprite2D").animation != "hurt":
						animation.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if(velocity.y > 0):
			if get_node("AnimatedSprite2D").animation != "hurt":
				animation.play("fall")
		move_and_slide()
	
	if(Game.playerCurrentHP <= 0):
		is_dead = true
		death_timer.start()
		get_node("AnimatedSprite2D").play("death")
		Game.playerCurrentHP = 10
		Game.Score = 0
		
func on_death_timeout():
	get_tree().change_scene_to_file("res://main.tscn")
	is_dead = false
	
	
func _on_knockback_timeout():
	is_knockback_active = false
	receives_knockback = false
	if is_on_floor():
		if velocity.x == 0:
			animation.play("idle")
		else:
			animation.play("run")
	else:
		if velocity.y > 0:
			animation.play("fall")
		else:
			animation.play("jump")

func _on_hostile_detect_area_entered(area):
	if "PlayerCollision" in area.name:
		receives_knockback = true
		receive_knockback(area.global_position,3,0.0167)
		get_node("AnimatedSprite2D").play("hurt")
	if "PlayerPush" in area.name:
		receives_knockback = true
		receive_knockback(area.global_position,20,0.0167)
		get_node("AnimatedSprite2D").play("hurt")

func receive_knockback(damage_source_pos : Vector2,received_damage: int,delta):
	if receives_knockback and not is_knockback_active:
		
		var knockback_direction = ($".".global_position - damage_source_pos).normalized()
		var knockback_force = knockback_direction * knockback_strength*received_damage
		velocity.y = -400
		velocity.x = 3*knockback_force.x
		knockback_timer.start() 

