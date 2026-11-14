extends CharacterBody2D

@onready var mc = $AnimatedSprite2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const gravity = 980
const run_speed = 400


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
	print("worked")
	velocity.y = JUMP_VELOCITY
	
	
func handle_fall(delta):
	velocity.y += gravity * delta

func _physics_process(delta: float) -> void:
	if is_on_floor() and Input.is_action_pressed("jump"):
		current_stat = mc_state.JUMP
	elif !is_on_floor():
		current_stat = mc_state.FALL
	elif Input.is_action_pressed("right") or Input.is_action_pressed("left"):
		current_stat = mc_state.WALK
	elif Input.is_action_pressed("run right") or Input.is_action_pressed("run left"):
		current_stat = mc_state.RUN
	else:
		current_stat = mc_state.IDLE
	handle_stat(delta)
	move_and_slide()
func handle_run(direction):
	if Input.is_action_pressed("run left"):
		direction -= 2
	elif Input.is_action_pressed("run right"):
		direction += 2
func handle_stat(delta):
	var direction = Vector2.ZERO
	match current_stat:
		mc_state.IDLE:
			velocity.x = 0
			mc.play("idle")
		mc_state.WALK:
			handle_walk(direction)
		mc_state.JUMP:
			print("wo")
			handle_jump()
		mc_state.FALL:

			handle_fall(delta)
		mc_state.RUN:
			handle_run(direction)
