extends RefCounted
class_name AttackHitboxContext

var handler: Character
var scene: WeaponHurtboxAttack
var parent: BaseWeapon

func _init(h: Character, s: WeaponHurtboxAttack, b: BaseWeapon) -> void:
	handler = h
	scene = s
	parent = b
