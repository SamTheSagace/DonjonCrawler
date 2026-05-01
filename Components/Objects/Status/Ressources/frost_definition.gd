extends StatusDefinition
class_name FrostDefinition

@export var slow := 0.25

func _init():
    type = ElementList.Type.FROST


func tick(_target: Character):
    _target._handle_slowed(slow, type)