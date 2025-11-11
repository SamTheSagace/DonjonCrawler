class_name HealthComponent
extends Node3D

@export var Max_health := 50

var health : float


func _ready():
	health = Max_health

func damage(attack: Attack):
	print(attack.attack_Damage)
	health -= attack.attack_Damage
	if health <= 0:
		get_parent().queue_free()
