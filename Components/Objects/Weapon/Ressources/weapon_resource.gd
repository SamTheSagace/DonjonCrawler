class_name WeaponResource
extends Resource

@export var name: String

@export var weapon_superType: WeaponParam.SuperType

@export var damage := 10.0
@export var knockback := 10.0


@export var statuses: Array[StatusDefinition] = []

@export var scene_weapon: PackedScene

func _ready():
	assert(scene_weapon != null)

func instantiate_weapon() -> BaseWeapon:
	var weapon := scene_weapon.instantiate() as BaseWeapon
	assert(weapon != null,
		"Scene must inherit BaseWeapon")
	return weapon
