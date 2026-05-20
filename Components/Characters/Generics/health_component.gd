class_name HealthComponent
extends Node3D

var Max_health := 50

var health: float
signal damageTaken(dmg)

func _ready():
	health = Max_health

func set_max_health(value: int):
	Max_health = value
	health = value

func handle_damage(value: float, _status: StatusType.List):
	health -= value

func handle_attack(attack: Attack):
	if attack.was_parried:
		return
	var finalDmg = attack.final_damage()
	damageTaken.emit(finalDmg)
	health -= finalDmg
