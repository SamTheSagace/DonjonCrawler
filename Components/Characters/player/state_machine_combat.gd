extends StateMachine
class_name StateMachineCombat

@export var WEAPON_MANAGER: WeaponManager

enum CombatState {
	IDLE,
	CHARGE,
	ATTACK,
	PARRY,
	CAST
}

const COMBAT_STATE_NAMES := {
	CombatState.IDLE: "CombatIdle",
	CombatState.CHARGE: "Charge",
	CombatState.ATTACK: "Attack",
	CombatState.PARRY: "Parry",
	CombatState.CAST: "Cast"
}

@export var initial_state := CombatState.IDLE

func child_state():
	for state_id in CombatState.values():
		var node_name = COMBAT_STATE_NAMES[state_id]
		var node:StateCombat = get_node_or_null(node_name)
		assert(node != null, "Missing state node: %s" % node_name)
		assert(node is State, "%s must extend State" % node_name)
		node.character = character
		node.state_machine = self
		node.weapon_manager = WEAPON_MANAGER
		states[state_id] = node

func transition_to(state_id: int, msg := {}):
	if not states.has(state_id):
		push_warning("State %s not found" % COMBAT_STATE_NAMES.get(state_id, state_id))
		return

	if current_state:
		current_state.exit()

	current_state = states[state_id]
	current_state.enter(msg)

func enter_initial_state():
	transition_to(initial_state)
