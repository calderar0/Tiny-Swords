class_name Enemy

extends CharacterBody2D



@export var health: int = 10

func damage(amount: int) -> void:
	health -= amount
	print("Inimigo recebeu dano de: ", amount, "a vida total é de: ", health)

