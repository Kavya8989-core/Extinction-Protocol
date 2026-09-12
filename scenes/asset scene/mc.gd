extends CharacterBody2D

@onready var animatiedsprite2d = $AnimatedSprite2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var is_attacking := false
var is_jumping := false

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
	if is_attacking == true:
		velocity.x = 0
	else:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	process_animation(direction)


func process_animation(direction: float) -> void:
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		animatiedsprite2d.play("attack1 right")
		await animatiedsprite2d.animation_finished
		is_attacking = false
	if is_attacking:
		return 
	if Input.is_action_just_pressed("jump"):
		is_jumping = true
		animatiedsprite2d.play("jump right")
		await animatiedsprite2d.animation_finished
		is_jumping = false
	if is_jumping :
		return
	elif direction > 0:
		animatiedsprite2d.flip_h = false
		animatiedsprite2d.play("walk right")
		
	elif direction < 0:
		animatiedsprite2d.flip_h = true
		animatiedsprite2d.play("walk right")
	else:
		animatiedsprite2d.play("idle right")
