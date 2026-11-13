extends CharacterBody2D

@onready var animatiedsprite2d = $AnimatedSprite2D
const walk_speed = 100
const run_speed = 200
const gravity = 980

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("right"):
		direction.x += 1
		animatiedsprite2d.play("walk right")
		animatiedsprite2d.flip_h= false
	elif Input.is_action_pressed("left"):
		direction.x -= 1
		animatiedsprite2d.play("walk right")
		animatiedsprite2d.flip_h = true
	velocity.x = walk_speed * direction.x
	if !is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
