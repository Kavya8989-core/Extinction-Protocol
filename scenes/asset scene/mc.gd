extends CharacterBody2D

@onready var animatiedsprite2d = $AnimatedSprite2D
const walk_speed = 100
const run_speed = 200

func _physics_process(delta: float) -> void:
	
	var direction = Vector2.ZERO
	if Input.is_action_pressed("right"):
		direction.x += 1
		animatiedsprite2d.play("walk right")
		animatiedsprite2d.flip_h= false
	if Input.is_action_pressed("left"):
		direction.x -= 1
		animatiedsprite2d.play("walk right")
		animatiedsprite2d.flip_h = true
	velocity = walk_speed * direction
	move_and_slide()
