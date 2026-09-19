class_name WeaponResource
extends Resource

@export var name: String

@export var weapon_superType: WeaponParam.SuperType

@export var damage := 10.0
@export var knockback := 10.0


@export var statuses: Array[StatusDefinition] = []

@export var scene_weapon: PackedScene

func instantiate_weapon(handler: Character) -> BaseWeapon:
	assert(scene_weapon != null, "WeaponResource has no scene_weapon assigned")
	var weapon := scene_weapon.instantiate() as BaseWeapon
	assert(weapon != null,
		"Scene must inherit BaseWeapon")
	return weapon
