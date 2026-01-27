extends StateCombat

func enter(msg := {}):
	print(msg.get("print","should have been hello world"))
	weapon_manager.start_attack()

func update(delta: float):
	if weapon_manager.attack_finished:
		state_machine.transition_to(StateMachineCombat.CombatState.IDLE, {"print":"attack finished, back to idle"})
