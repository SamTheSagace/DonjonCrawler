extends DamageReceiver


@export var SMC: StateMachineCombat
@export var CHARACTER: Character

func _ready() -> void:
	super._ready()
	assert(SMC != null )

func resolve_attack(attack: Attack) -> void:
	SMC._resolve_attack(attack)
	CHARACTER._resolve_knockback(attack)
	HEALTH.damage(attack)
