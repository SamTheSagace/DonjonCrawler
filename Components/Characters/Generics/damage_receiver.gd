extends Node
class_name DamageReceiver

@export var CHARACTER: Character

var HITBOX: HitboxComponent
var HEALTH: HealthComponent

func _ready() -> void:
	assert(CHARACTER != null)
	HITBOX = CHARACTER.HITBOX
	HEALTH = CHARACTER.HEALTH_COMPONENT
	HITBOX.hit_taken.connect(resolve_attack)

func resolve_attack(attack: Attack) -> void:
	HEALTH.handle_attack(attack)
