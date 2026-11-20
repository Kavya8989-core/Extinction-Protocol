extends CharacterBody2D

var is_mc = false
const SPEED = 200
const JUMP_VELOCITY = -400.0
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
			handle_run(direction)

func handle_run(direction):
	pass
	

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("mc"):
		is_mc = true


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("mc"):
		is_mc = false
