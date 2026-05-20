class_name StatusDefinition
extends Resource

var type: StatusList.Type
@export var duration := 5.0
@export var tick_rate := 1.0
@export var damageOnApply := 5.0

func apply(_target: Character):
	_target._resolve_status_damage(damageOnApply, type)


func merge_from(new_status: StatusDefinition):
	if (new_status.type != type):
		return
	duration = new_status.duration
	damageOnApply = max(damageOnApply, new_status.damageOnApply)
	tick_rate = min(tick_rate, new_status.tick_rate)

func tick(_target: Character, _delta):
	pass

func _clean_up(_target: Character):
	pass
