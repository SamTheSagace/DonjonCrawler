class_name WeaponResource
extends Resource


@export var weapon_type: WeaponParameter.Type
@export var world_model: PackedScene

@export var damage := 10.0
@export var knockback := 10.0


@export var statuses: Array[StatusDefinition] = []
