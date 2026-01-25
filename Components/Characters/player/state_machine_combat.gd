extends StateMachine
class_name StateMachineCombat

signal attack_requested()

enum CombatState {
	IDLE,
	ATTACK,
	PARRY,
	CAST
}

const COMBAT_STATE_NAMES := {
	CombatState.IDLE: "Idle",
	CombatState.ATTACK: "Attack",
	CombatState.PARRY: "Parry",
	CombatState.CAST: "Cast"
}

func _ready():
	super._ready()
	character.attackInput.connect(_on_attackInput)

func child_state():
	for state_id in CombatState.values():
		var node_name = COMBAT_STATE_NAMES[state_id]
		var node = get_node_or_null(node_name)
		assert(node != null, "Missing state node: %s" % node_name)
		assert(node is State, "%s must extend State" % node_name)
		states[state_id] = node

func _on_attackInput():
	emit_signal("attack_requested")
