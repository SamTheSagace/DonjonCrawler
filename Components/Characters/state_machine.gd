extends Node
class_name StateMachine

var current_state: State
var character: Character
var states := {}

func _ready():
	character = owner as Character
	assert(character != null)

	child_state()
	enter_initial_state()

func child_state():
	# Meant to be overridden
	pass

func enter_initial_state():
	# Meant to be overridden
	pass

func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func transition_to(_state_id, _msg := {}):
	push_error("transition_to() not implemented in %s" % get_class())
