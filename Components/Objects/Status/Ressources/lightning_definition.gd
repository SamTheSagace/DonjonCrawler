extends StatusDefinition
class_name LightningDefinition

@export var stunned := 1.0

func _init():
	type = StatusList.Type.LIGHTNING


func tick(_target: Character):
	_target._resolve_stunned(stunned, type)
