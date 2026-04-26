extends DamageReceiver
class_name PlayerDamageReceiver

var PLAYER: Player:
	get:
		return CHARACTER as Player

@export var SMC: StateMachineCombat

func _ready() -> void:
	super._ready()
	assert(SMC != null)

func resolve_attack(attack: Attack) -> void:
	SMC._resolve_attack(attack)
	PLAYER._resolve_knockback(attack)
	PLAYER._resolve_status_inflicted(attack)
	HEALTH.handle_attack(attack)
