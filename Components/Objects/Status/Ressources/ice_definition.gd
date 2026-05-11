extends StatusDefinition
class_name IceDefinition

@export var slow := 0.25

func _init():
	type = StatusList.Type.FROST


func tick(_target: Character):
	_target._resolve_slowed(slow, type)
