extends StatusDefinition
class_name PoisonDefinition


@export var damageOnTick := 3.0

func _init():
	type = StatusList.Type.POISON

func tick(_target: Character):
	_target._resolve_status_damage(damageOnTick, type)
