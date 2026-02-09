extends DamageReceiver

@export var HITBOX : HitboxComponent
@export var HEALTH : HealthComponent
@export var SMC: StateMachineCombat


func _ready() -> void:
	assert(SMC != null && HITBOX != null)
	HITBOX.damage_taken.connect(resolve_attack)

func resolve_attack(attack: Attack) -> void:
	SMC._resolve_attack(attack)
	HEALTH.damage(attack)
