extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	get_node("AnimatedSprite2D").play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity * delta
	if get_node("AnimatedSprite2D").animation != "death":
		get_node("AnimatedSprite2D").play("idle")
	velocity.x = 0
	move_and_slide()


func _on_player_death_body_entered(body):
	if body.name == "Player":
		death()

func death():
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
		Game.playerCurrentHP -= 1
		Game.HealthChange.emit()
