extends StateCombat

func enter(_msg := {}):
	weapon_action.start_attack()

func update(_delta: float):
	if character.wants_to_parry && weapon_manager.weapon_resource.weapon_superType == WeaponParam.SuperType.MELEE:
		state_machine.transition_to(StateMachineCombat.CombatState.PARRY, {"print": "attack canceled, switch to parry"})
	if weapon_action.attack_finished:
		state_machine.transition_to(StateMachineCombat.CombatState.IDLE, {"print": "attack finished, back to idle"})
		return
