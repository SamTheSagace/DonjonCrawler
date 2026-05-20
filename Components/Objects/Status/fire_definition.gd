extends StatusDefinition
class_name FireDefinition


@export var fear := 0.25

@export var damageOnTick := 2.0

func _init():
	type = StatusList.Type.FIRE

func merge_from(new_status: StatusDefinition):
	super.merge_from(new_status)
	fear = max(fear, new_status.fear)
	damageOnTick = max(damageOnTick, new_status.damageOnTick)


func tick(_target: Character, _delta):
	_target._resolve_status_damage(damageOnTick, type)
