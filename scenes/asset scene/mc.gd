extends CharacterBody2D

@onready var mc = $AnimatedSprite2D
const SPEED = 100
const JUMP_VELOCITY = -450.0
const gravity = 980
const run_speed = 200
var is_running = false

enum mc_state{
	IDLE,
	WALK,
	JUMP,
	FALL,
	RUN
}
var current_stat = mc_state.IDLE



func handle_walk(direction):
	if Input.is_action_pressed("left"):
		mc.flip_h = true
		mc.play("walk right")
		direction.x -= 1
		
	elif Input.is_action_pressed("right"):
		mc.play("walk right")
		mc.flip_h = false
		direction.x += 1
	
	velocity = direction * SPEED

func handle_jump():
	mc.play("jump")
	velocity.y = JUMP_VELOCITY
	
	
func handle_fall(delta):
	velocity.y += gravity * delta
func handle_run(direction):
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	velocity = direction * run_speed

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_SHIFT):
		print("SHIFT PRESSED")

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		current_stat = mc_state.JUMP
	elif !is_on_floor():
		current_stat = mc_state.FALL
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		if Input.is_action_pressed("run"):
			current_stat = mc_state.RUN
		else:
			current_stat = mc_state.WALK
	else:
		current_stat = mc_state.IDLE

	handle_stat(delta)
	move_and_slide()
func handle_stat(delta):
	var direction = Vector2.ZERO
	match current_stat:
		mc_state.IDLE:
			velocity.x = 0
			mc.play("idle")
		mc_state.WALK:
			handle_walk(direction)
		mc_state.JUMP:
			handle_jump()
		mc_state.FALL:

			handle_fall(delta)
		mc_state.RUN:
			print("worked")
			handle_run(direction)
func _input(event):
	if event is InputEventKey:
		print("Key: ", event.as_text())
		print("Pressed: ", event.pressed)
