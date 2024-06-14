extends CharacterBody2D

@export var speed: float = 1

func _physics_process(delta: float) -> void:
	var player_position = Vector2(0 , 0)
	var difference = player_position - position
	var input_vector = difference.normalized()
	velocity = input_vector * speed * 100.0
	
	
	move_and_slide()
