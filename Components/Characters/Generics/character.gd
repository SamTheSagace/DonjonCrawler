extends CharacterBody3D
class_name Character

@export var MAX_HEALTH := 60
@export var SPEED := 5.0
@export var JUMP_VELOCITY := 4.5
@export var SNEAK_SPEED := 0.5
@export var SPRINT_SPEED := 1.5
@export var HEALTH_COMPONENT : HealthComponent
@export var MOVEMENT_COMPONENT : MovementComponent
@export var HITBOX : HitboxComponent
var knockack_direction : Vector3
var wants_to_attack := false
var wants_to_parry := false
var stun_timer :=0.0

signal attackInput()
var knockback_velocity: Vector3 = Vector3.ZERO

func _ready():
	if HEALTH_COMPONENT != null:
		HEALTH_COMPONENT.set_max_health(MAX_HEALTH)
	if MOVEMENT_COMPONENT != null:
		MOVEMENT_COMPONENT.set_stats(SPEED, JUMP_VELOCITY, SNEAK_SPEED, SPRINT_SPEED)

func _resolve_knockback(attack: Attack):
	stun_timer = 1
	var attacker_position = attack.attacker.global_position
	knockack_direction = (self.global_transform.origin - attacker_position)
	knockack_direction.y = 0
	knockack_direction = knockack_direction.normalized()
	print("knocked back !", attacker_position, knockack_direction)
	if knockack_direction.length_squared() > 0.001:
		knockback_velocity = knockack_direction.normalized() * attack.knockback
