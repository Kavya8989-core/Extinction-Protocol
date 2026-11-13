extends CharacterBody2D

@onready var mc = $AnimatedSprite2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const gravity = 980


enum mc_state{
	IDLE,
	WALK,
	JUMP,
	FALL
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
			print("wo")
			handle_jump()
		mc_state.FALL:

			handle_fall(delta)
