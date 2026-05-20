class_name WeaponResource
extends Resource

@export var name: String
@export var weapon_type: WeaponType.List
@export var world_model: PackedScene

@export var damage := 10.0
@export var knockback := 10.0


@export var statuses: Array[StatusDefinition] = []
