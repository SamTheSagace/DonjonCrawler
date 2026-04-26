extends Node
class_name DamageReceiver
@export var HITBOX : HitboxComponent
@export var HEALTH : HealthComponent

func _ready() -> void:
	assert(HEALTH !=null && HITBOX != null)
	HITBOX.damage_taken.connect(resolve_attack)

func resolve_attack(attack: Attack) -> void:
	HEALTH.damage(attack)
