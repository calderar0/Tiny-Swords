extends CharacterBody2D
 
@export var speed: float = 3
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var is_running: bool = false

func _physics_process(delta: float) -> void:
	#pega a direção e velocidade
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	#deadzone (isso aqui é por causa do controle pae)
	var deadzone = 0.15
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0
		
	#muda a velocidade
	var target_velocity = input_vector * speed * 100
	velocity = lerp(velocity,target_velocity, 0.05)
	move_and_slide()
	
	#muda a var isrunning
	var was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
	#animação
	if was_running != is_running:
		if is_running:
			animation_player.play("run")
		else:
			animation_player.play("idle")
	
	#gira sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
	
	
