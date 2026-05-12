extends StatusDefinition
class_name PoisonDefinition


@export var damageOnTick := 3.0

func _init():
	type = StatusList.Type.POISON

func merge_from(new_status: StatusDefinition):
	super.merge_from(new_status)
	damageOnTick = max(damageOnTick, new_status.damageOnTick)

func tick(_target: Character):
	_target._resolve_status_damage(damageOnTick, type)
