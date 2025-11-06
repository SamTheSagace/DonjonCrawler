class_name HealthComponent
extends Node3D

@export var Max_health := 20
var health : float


func _ready():
	health = Max_health

func damage(attack: Attack):
	print(attack.attack_Damage)
	health -= attack.attack_Damage
	 
