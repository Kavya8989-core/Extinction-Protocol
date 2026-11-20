extends CharacterBody2D
@onready var dino: AnimatedSprite2D = $AnimatedSprite2D


var is_mc = false
const SPEED = 200
const JUMP_VELOCITY = -400.0
var direction = ""
enum dino_state  {
	RUN,
	JUMB,
	STOP,
	ATTACK
}
var current_state = dino_state.STOP


func _physics_process(delta: float) -> void:
	var distance = Vector2.ZERO
	if is_mc:
		current_state = dino_state.RUN
	handle_state()

func handle_state():
	var direction
	match current_state:
		dino_state.STOP:
			velocity = Vector2.ZERO
		dino_state.RUN:
			handle_run()

func handle_run():
	var distance = (get_tree().get_first_node_in_group("mc").global_position - global_position).normalized()
	velocity = distance * SPEED
	move_and_slide()
	if velocity.x > 0:
		dino.play("running")
		dino.flip_h = false
	if velocity.x < 0 :
		dino.play("running")
		dino.flip_h = true
	
	
	

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("mc"):
		is_mc = true


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("mc"):
		is_mc = false
