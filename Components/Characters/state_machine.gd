# StateMachine.gd
extends Node
class_name StateMachine

@export var initial_state: NodePath

var current_state: State
var character: Character
var states := {}

func _ready():
	character = owner as Character
	assert(character != null)
	# Cache child states
	child_state()
	# Enter initial state
	assert(initial_state != null)
	transition_to(initial_state)

func child_state():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.character = character
			child.state_machine = self

func transition_to(state_name: String, msg := {}):
	if not states.has(state_name):
		push_warning("State %s not found" % state_name)
		return

	if current_state:
		current_state.exit()

	current_state = states[state_name]
	current_state.enter(msg)

func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)
