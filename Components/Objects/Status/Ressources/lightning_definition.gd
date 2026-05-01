extends StatusDefinition
class_name LightningDefinition

@export var stunned := 1.0

func _init():
	type = ElementList.Type.LIGHTNING


func tick(_target: Character):
	_target.resolve_stunned(stunned, type)
