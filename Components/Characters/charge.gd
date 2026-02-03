extends StateCombat


func enter(msg := {}):
	pass

func update(delta: float):
	if !character.wants_to_attack:
		state_machine.transition_to(StateMachineCombat.CombatState.ATTACK, {"print":"attack"})

func exit():
	print("stop charging attack, attacking")
