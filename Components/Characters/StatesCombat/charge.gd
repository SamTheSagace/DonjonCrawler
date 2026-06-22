extends StateCombat


func enter(_msg := {}):
	weapon_action.start_charge()
	pass

func update(_delta: float):
	if !character.wants_to_attack:
		state_machine.transition_to(StateMachineCombat.CombatState.ATTACK, {"print": "attack"})
		return

func exit():
	pass
