extends StatusDefinition
class_name BurnDefinition


@export var fear := 0.25

@export var damageOnTick := 2.0

func _init():
    type = ElementList.Type.FIRE


func tick(_target: Character):
    _target._resolve_status_damage(damageOnTick, type)
