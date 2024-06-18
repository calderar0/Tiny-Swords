extends CharacterBody2D
 
@export var speed: float = 3
@export var sword_damage: int = 2

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword_area: Area2D = $SwordArea

#variáveis comuns player
var input_vector: Vector2 = Vector2(0 , 0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
#padronização de ataques player
var random_up = 1
var random_up2 = 2
var random_down = 1
var random_down2 = 2
var random_side = 1
var random_side2 = 2

func _process(delta: float) -> void:
	#game manager
	GameManager.player_position = position
	#le o input
	read_input()
	#cooldown
	update_attack_cooldown(delta)
	#processa animação e rotação
	play_run_idle_animation()
	if not is_attacking:
		rotate_sprite()
	#sistema de ataque
	if Input.is_action_just_pressed("attack"):
		attack(input_vector)

func read_input() -> void:
		#pega a direção e velocidade
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#deadzone (isso aqui é por causa do controle pae)
	var deadzone = 0.15
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0
	
	#muda a var isrunning
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func play_run_idle_animation() -> void:
			#animação
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")
	
func rotate_sprite() -> void:
		#gira sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true

func update_attack_cooldown(delta: float) -> void: 
		#cooldown ataque
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func _physics_process(delta: float) -> void:
	#muda a velocidade
	var target_velocity = input_vector * speed * 100
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity,target_velocity, 0.05)
	move_and_slide()

func up_attack_random_anim() -> void:
	if random_up != random_up2:
		animation_player.play("attack_up1")
		random_up2 = 1
	else:
		animation_player.play("attack_up2")
		random_up2 = 2

func down_attack_random_anim() -> void:
	if random_down != random_down2:
		animation_player.play("attack_down1")
		random_down2 = 1
	else:
		animation_player.play("attack_down2")
		random_down2 = 2

func side_attack_random_anim() -> void:
	if random_side != random_side2:
		animation_player.play("attack_side1")
		random_side2 = 1
	else:
		animation_player.play("attack_side2")
		random_side2 = 2

func attack(input_vector) -> void:
	if is_attacking:
		return
	
	#attack up
	if input_vector.y < 0:
		up_attack_random_anim()
		attack_cooldown = 0.6
	#attack down
	elif input_vector.y > 0:
		down_attack_random_anim()
		attack_cooldown = 0.6
	#attack side
	else:
		side_attack_random_anim()
		attack_cooldown = 0.6
	#marca ataque
	is_attacking = true

func deal_damage_to_enemies() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	var animation_list = animation_player.get_animation_list()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			if sprite.frame_coords.y == 4 || sprite.frame_coords.y == 5:
				attack_direction = Vector2.DOWN
			elif sprite.frame_coords.y == 6 || sprite.frame_coords.y == 7:
				attack_direction = Vector2.UP
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= 0.35:
				enemy.damage(sword_damage)
