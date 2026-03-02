extends CharacterBody3D
class_name Character

@export var MAX_HEALTH := 60
@export var SPEED := 5.0
@export var JUMP_VELOCITY := 4.5
@export var SNEAK_SPEED := 0.5
@export var SPRINT_SPEED := 1.5
@export var HEALTH_COMPONENT: HealthComponent
@export var MOVEMENT_COMPONENT: MovementComponent
@export var SMC: StateMachineCombat

var wants_to_attack := false
var wants_to_parry := false
var is_stunned:= false
var stun_timer :=0.0

signal attackInput()
var knockback_velocity: Vector3 = Vector3.ZERO

func _ready():
	if HEALTH_COMPONENT != null:
		HEALTH_COMPONENT.set_max_health(MAX_HEALTH)
	if MOVEMENT_COMPONENT != null:
		MOVEMENT_COMPONENT.set_stats(SPEED, JUMP_VELOCITY, SNEAK_SPEED, SPRINT_SPEED)

func _resolve_knockback(attack: Attack):
	is_stunned = true
	stun_timer = 0.2
	var direction = (self.global_transform.origin - attack.attacker_position)
	direction.y = 0
	direction = direction.normalized()
	print("knocked back !", attack.attacker_position, direction)
	if direction.length_squared() > 0.001:
		knockback_velocity = direction.normalized() * attack.knockback
