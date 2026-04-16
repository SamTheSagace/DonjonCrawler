class_name Attack
extends Resource

var base_damage := 10.0
var damage_multiplier := 1.0
var knockback := 10.0
var was_parried := false
var attacker : Character 


func final_damage() -> float:
	return base_damage * damage_multiplier
