extends StateCombat

@export var perfect_window := 0.5
@export var parry_duration := 0.8

var elapsed := 0.0
var idle_delay_timer := 0.0
const IDLE_DELAY := 0.2

func enter(_msg := {}):
	elapsed = 0.0
	idle_delay_timer = 0.0
	weapon_action.start_parry()

func update(delta: float):
	elapsed += delta
	if !character.wants_to_parry:
		if character.wants_to_attack:
			weapon_action.go_to_idle()
			state_machine.transition_to(StateMachineCombat.CombatState.CHARGE)
			return
		if weapon_action.parry_finished:
			weapon_action.go_to_idle()
			idle_delay_timer = 0.0
			state_machine.transition_to(StateMachineCombat.CombatState.IDLE)
			return
	if character.wants_to_attack:
		weapon_action.go_to_idle()
		state_machine.transition_to(StateMachineCombat.CombatState.CHARGE)
		return


func resolve_on_hit(attack: Attack):
	perfect_parry(attack)
	if elapsed <= perfect_window:
		# Perfect parry: negate damage
		attack.damage_multiplier = 0.0
		attack.was_parried = true

	else:
		# Regular parry: reduce damage
		attack.damage_multiplier = 0.2

func perfect_parry(attack: Attack):
	var attacker = attack.attacker
	var respattack = Attack.new()
	respattack.attacker = character
	respattack.weapon_resource = weapon_manager.weapon_resource.duplicate()
	respattack.damage_multiplier = 0.0
	attacker._resolve_knockback(respattack)
