extends Resource
class_name Attack

var weapon_resource: WeaponResource
var damage_multiplier := 1.0

var attacker: Character

var was_parried := false

func final_damage() -> float:
	if (weapon_resource):
		return weapon_resource.damage * damage_multiplier
	return 0.0
