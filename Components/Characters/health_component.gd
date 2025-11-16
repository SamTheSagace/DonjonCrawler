class_name HealthComponent
extends Node3D

@export var Max_health := 50

var health : float
signal damageTaken(dmg)

func _ready():
	health = Max_health

func damage(attack: Attack):
	emit_signal('damageTaken',attack.attack_Damage)
	health -= attack.attack_Damage
	
	if health <= 0:
		get_parent().queue_free()
