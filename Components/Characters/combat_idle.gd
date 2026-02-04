extends StateCombat

func update(delta):
	if character.wants_to_attack:
		state_machine.transition_to(StateMachineCombat.CombatState.CHARGE)
		return
	if character.wants_to_parry && weapon_manager.weapon_resource.weapon_type == WeaponType.Type.MELEE:
		state_machine.transition_to(StateMachineCombat.CombatState.PARRY)
		return

func enter(msg := {}):
	print("is now idle", character.wants_to_parry)
