extends StateCombat


func enter(msg := {}):
	weapon_manager.start_charge()
	pass

func update(delta: float):
	if !character.wants_to_attack:
		state_machine.transition_to(StateMachineCombat.CombatState.ATTACK, {"print":"attack"})
		return

func exit():
	print("stop charging attack, attacking")
