extends StateCombat

func enter(_msg := {}):
	weapon_manager.start_attack()

func update(_delta: float):
	if weapon_manager.attack_finished:
		state_machine.transition_to(StateMachineCombat.CombatState.IDLE, {"print": "attack finished, back to idle"})
		return
