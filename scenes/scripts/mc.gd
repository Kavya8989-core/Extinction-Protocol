extends CharacterBody2D
@onready var walk_sound :  AudioStreamPlayer2D = $sfx/walk
@onready var walk_timer = $sfx/walk/Timer
@onready var mc = $AnimatedSprite2D
@onready var idle_col: CollisionShape2D = $CollisionShape2D
@onready var jump_col_: CollisionShape2D = $"CollisionShape2D(jump)"
@onready var wall_detect: RayCast2D = $"wall detect"

var climb_speed = 0.0
const max_climb = 120

const SPEED = 250
const JUMP_VELOCITY = -300.0
const gravity = 980
const run_speed = 200
var last_direction = ""
var on_ledge = false
var climb_distance = 0
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
	if not on_ledge:

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
func hang_ledge(delta):
	on_ledge = true
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("climbing up"):
		
		climb_up(delta)
	else:
		mc.play("hang")
	

func climb_up(delta):
	
	
	velocity.y -= 120
	climb_distance += 1*delta 
	mc.play("climbing")
	if climb_distance >= 0.35:
		velocity.y = 0
		if climb_distance >= 1.35:
			on_ledge = false
	

func _physics_process(delta: float) -> void:

	if wall_detect.is_colliding() and not is_on_floor():
		current_stat = mc_state.CLIMB
		on_ledge = true
		velocity = Vector2.ZERO

	elif on_ledge:
		current_stat = mc_state.CLIMB

	elif is_on_floor() and Input.is_action_just_pressed("jump"):
		current_stat = mc_state.JUMP

	elif not is_on_floor():
		current_stat = mc_state.FALL

	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		if Input.is_action_pressed("slide"):
			current_stat = mc_state.SLIDE
		else:
			current_stat = mc_state.WALK

	else:
		current_stat = mc_state.IDLE

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
		mc_state.CLIMB:
			hang_ledge(delta)
		

func _ready() -> void:
	walk_sound.attenuation = 0
	
