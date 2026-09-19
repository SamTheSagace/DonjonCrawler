extends Node
class_name DamageReceiver

@export var character: Character

var hitbox: HitboxComponent
var HEALTH: HealthComponent

func _ready() -> void:
	assert(character != null)
	hitbox = character.hitbox
	HEALTH = character.health_component
	hitbox.hit_taken.connect(resolve_attack)

func resolve_attack(attack: Attack) -> void:
	character._resolve_status_inflicted(attack)
	HEALTH.handle_attack(attack)
