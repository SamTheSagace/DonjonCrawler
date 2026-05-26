extends StatusDefinition
class_name LightningDefinition

@export var stunned := 1.0

func _init():
	type = StatusType.List.LIGHTNING

func merge_from(new_status: StatusDefinition):
	super.merge_from(new_status)
	stunned = max(stunned, new_status.stunned)

func tick(_target: Character, _delta):
	_target._resolve_stunned(stunned, type, _delta)
