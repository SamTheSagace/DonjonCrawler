extends StateCombat

func enter(msg := {}):
	weapon_manager.start_parry()
	await get_tree().create_timer(1).timeout
	print("is now parrying")

func update(delta: float):
	if !character.wants_to_parry:
		weapon_manager.go_to_idle()
		state_machine.transition_to(StateMachineCombat.CombatState.IDLE)
	if character.wants_to_attack:
		weapon_manager.go_to_idle()
		state_machine.transition_to(StateMachineCombat.CombatState.CHARGE)
