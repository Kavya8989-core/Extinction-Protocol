extends CharacterBody2D
@onready var walk_sound :  AudioStreamPlayer2D = $sfx/walk
@onready var walk_timer = $sfx/walk/Timer
@onready var mc = $AnimatedSprite2D
@onready var idle_col: CollisionShape2D = $CollisionShape2D
@onready var jump_col_: CollisionShape2D = $"CollisionShape2D(jump)"

const SPEED = 250
const JUMP_VELOCITY = -300.0
const gravity = 980
const run_speed = 200
var last_direction = ""
var can_descend = false
var current_gravity = gravity
# creating a state machine for different state
enum mc_state{
	IDLE,
	WALK,
	JUMP,
	FALL,
	RUN,
	SLIDE,
	CLIMB
}
var current_stat = mc_state.IDLE


# handleing walk condition
func handle_walk(direction):
	idle_col.disabled = false
	if Input.is_action_pressed("left"):
		last_direction = "left"
		mc.flip_h = true
		mc.play("run")
		direction.x -= 1
		
	elif Input.is_action_pressed("right"):
		last_direction = "right"
		mc.play("run")
		mc.flip_h = false
		direction.x += 1
	
	velocity = direction * SPEED
#handling jump condition
func handle_jump():
	idle_col.disabled = true
	jump_col_.disabled = false
	mc.play("jump")
	velocity.y = JUMP_VELOCITY
	
# handling falling condition
func handle_fall(delta):
	if not can_descend:

		velocity.y += current_gravity * delta
# handling run 
func handle_run(direction):
	
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	velocity = direction * run_speed
func handle_slide():

	mc.play("slide")

func _physics_process(delta: float) -> void:

	# assigning the state according to the input

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		current_stat = mc_state.JUMP
	elif !is_on_floor() and not can_descend:
		current_stat = mc_state.FALL
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		if Input.is_action_pressed("slide"):
			current_stat = mc_state.SLIDE
		else:
			current_stat = mc_state.WALK
	else:
		current_stat = mc_state.IDLE
	# func calling and other stuff
	handle_stat(delta)
	move_and_slide()
	
# handling all the state and transfering to there func
func handle_stat(delta):
	var direction = Vector2.ZERO
	match current_stat:
		mc_state.IDLE:
			idle_col.disabled = false
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
		mc_state.SLIDE:
			print("working")
			handle_slide()
		

func _ready() -> void:
	walk_sound.attenuation = 0
	
