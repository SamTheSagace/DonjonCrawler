class_name StatusDefinition
extends Resource

var type: ElementList.Type
@export var duration := 5.0
@export var tick_rate := 1.0
@export var damageOnApply := 5.0

func apply(_target: Character):
	_target._resolve_status_damage(damageOnApply, type)

func tick(_target: Character):
	pass
