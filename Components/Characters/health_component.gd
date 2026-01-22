class_name HealthComponent
extends Node3D

var Max_health := 50

var health : float
signal damageTaken(dmg)

func _ready():
	health = Max_health
	
func set_max_health(value: int):
	Max_health = value
	health = value

func damage(attack: Attack):
	emit_signal('damageTaken',attack.attack_Damage)
	health -= attack.attack_Damage
