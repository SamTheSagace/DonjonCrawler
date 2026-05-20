extends CharacterBody3D
class_name Character
@export var MAX_HEALTH := 60
@export var SPEED := 5.0
var FINALSPEED: float
@export var JUMP_VELOCITY := 4.5
@export var SNEAK_SPEED := 0.5
@export var SPRINT_SPEED := 1.5
@export var HEALTH_COMPONENT: HealthComponent
@export var MOVEMENT_COMPONENT: MovementComponent
@export var HITBOX: HitboxComponent

var wants_to_attack := false
var wants_to_parry := false
signal attackInput()

var knockack_direction: Vector3
var knockback_velocity: Vector3 = Vector3.ZERO
var stun_timer := 0.0


func is_stunned() -> bool:
	return stun_timer > 0.0
func is_slowed() -> bool:
	return FINALSPEED < SPEED

var status_inflicted: Array[StatusDefinition] = []

var status_type_modifiers: Array[StatusDefinition] = []

func _ready():
	assert(HEALTH_COMPONENT != null && HITBOX != null)
	HEALTH_COMPONENT.set_max_health(MAX_HEALTH)
	FINALSPEED = SPEED
	if MOVEMENT_COMPONENT != null:
		MOVEMENT_COMPONENT.set_stats(SPEED, JUMP_VELOCITY, SNEAK_SPEED, SPRINT_SPEED)

func _process(_delta: float) -> void:
	_resolve_status_decay(_delta)

func _physics_process(_delta: float) -> void:
	pass


func _resolve_knockback(attack: Attack):
	stun_timer += 0.4
	var knockbackPower = attack.weapon_resource.knockback
	var attacker_position = attack.attacker.global_position
	knockack_direction = (self.global_transform.origin - attacker_position)
	knockack_direction.y = 0
	knockack_direction = knockack_direction.normalized()
	if knockack_direction.length_squared() > 0.001:
		knockback_velocity = knockack_direction.normalized() * knockbackPower

func _resolve_status_damage(value: float, status: StatusType.List):
	HEALTH_COMPONENT.handle_damage(value, status)

func add_status(status: StatusDefinition):
	var incoming := status.duplicate(true)
	for s: StatusDefinition in status_inflicted:
		if s.type == incoming.type:
			s.merge_from(incoming)
			s.apply(self )
			return
	status_inflicted.append(incoming)
	incoming.apply(self )

func _resolve_status_inflicted(attack: Attack):
	var statuses = attack.weapon_resource.statuses
	for status: StatusDefinition in statuses:
		add_status(status)


func _handle_slowed(slowed_value: float):
	FINALSPEED = SPEED * slowed_value

func _resolve_stunned(_stunned: float, _type: StatusType.List, _delta):
	stun_timer += _delta


func _resolve_status_decay(_delta: float):
	for status: StatusDefinition in status_inflicted:
		status.duration -= _delta
		if status.duration > 0:
			status.tick(self , _delta)
		else:
			status._clean_up(self )
			status_inflicted.erase(status)
