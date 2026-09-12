extends CharacterBody2D

@onready var animatiedsprite2d = $AnimatedSprite2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	process_animation(direction)


func process_animation( direction: float) -> void:
	if direction > 0:
		animatiedsprite2d.flip_h = false
		animatiedsprite2d.play("walk right")
		
	elif direction < 0:
		animatiedsprite2d.flip_h = true
		animatiedsprite2d.play("walk right")
	else:
		animatiedsprite2d.play("idle right")
