extends CharacterBody2D


const SPEED = 200
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	var distance = Vector2.ZERO


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("mc"):
		print("mc detected")


func _on_attack_range_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
