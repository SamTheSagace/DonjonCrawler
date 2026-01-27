extends StateCombat

func update(delta):
	if character.wants_to_attack:
		print("attacking")
		state_machine.transition_to(StateMachineCombat.CombatState.CHARGE)

func enter(msg := {}):
	print("is now idle")
