extends StatusDefinition
class_name FrostDefinition

@export var slow := 0.25

func _init():
	type = StatusList.Type.FROST

func merge_from(new_status: StatusDefinition):
	super.merge_from(new_status)
	slow = max(slow, new_status.slow)

func tick(_target: Character, _delta):
	_target._handle_slowed(slow)

func _clean_up(_target: Character):
	_target._handle_slowed(1.0)
