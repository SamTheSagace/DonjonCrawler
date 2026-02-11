extends DamageReceiver


@export var SMC: StateMachineCombat


func _ready() -> void:
	super._ready()
	assert(SMC != null )

func resolve_attack(attack: Attack) -> void:
	SMC._resolve_attack(attack)
	HEALTH.damage(attack)
