extends CharacterBody2D

@onready var animatiedsprite2d = $AnimatedSprite2D
const walk_speed = 100
const run_speed = 200
const gravity = 980
const jump_velo = 400

enum player_stat {
	IDLE,
	JUMP,
	WALK,
	FALL
}
var current_stat = player_stat.IDLE
func update_stat():
	if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
		current_stat = player_stat.WALK
	if is_on_floor() and Input.is_action_pressed("jump"):
		current_stat = player_stat.JUMP
	if !is_on_floor():
		current_stat = player_stat.FALL

func handle_walk(direction):
	if Input.is_action_pressed("right"):
		direction.x += 1
	elif Input.is_action_pressed("left"):
		direction.x -= 1
	velocity.x = walk_speed * direction.x
	process_animation(direction)
func manage_stat(delta):
	match current_stat:
		player_stat.WALK:
			var direction = Vector2.ZERO
			handle_walk(direction)
		player_stat.JUMP:
			handle_jump(delta)
		player_stat.FALL:
			handle_fall(delta)
		
func _physics_process(delta: float) -> void:
	update_stat()
	manage_stat(delta)
	move_and_slide()
func handle_jump(delta):
	velocity.y = -jump_velo
func handle_fall(delta):
	velocity.y += delta * gravity
func process_animation(direction):
	if direction.x > 0:
		animatiedsprite2d.play("walk right")
		animatiedsprite2d.flip_h = false
	if direction.x < 0:
		animatiedsprite2d.flip_h = true
		animatiedsprite2d.play("walk right")
