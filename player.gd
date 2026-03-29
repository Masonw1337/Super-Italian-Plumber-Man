extends CharacterBody2D

var is_dying = false
var is_jumping = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var death_timer = $death_timer
@onready var animated_sprite_2D = $AnimatedSprite2D

func _ready():
	add_to_group("Player")
	death_timer.connect("timeout", Callable(self, "_on_DeatheTimer_timeout"))

func _physics_process(delta):
	if is_dying:
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		is_jumping = false
	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	update_animation(direction)
	move_and_slide()

func update_animation(direction):
	if is_dying:
		return
	if is_jumping:
		animated_sprite_2D.play("jump")
	elif  direction != 0:
		animated_sprite_2D.flip_h = (direction < 0)
		animated_sprite_2D.play("run")
	else:
		animated_sprite_2D.play("idle")


func _on_hitbox_body_entered(body):
	if body.is_in_group("Enemy") and body.is_alive:
		die()

func die():
	if is_dying:
		return
		
	is_dying = true
	animated_sprite_2D.play("dead")
	await move_player_up_and_down()
	Global.player_lives -= 1
	if Global.player_lives > 0:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://gameover.tscn")

func move_player_up_and_down():
	var start_position = position
	var up_position = start_position + Vector2(0, -100)
	var down_position = start_position + Vector2(0, 600)
	
	while position.y > up_position.y:
		position.y -= 4
		await get_tree().create_timer(0.01).timeout
		
	while position.y < down_position.y:
		position.y += 4
		await get_tree().create_timer(0.01).timeout
		
func on_DeathTimer_timeout():
	get_tree().reload_current_scene()
	
