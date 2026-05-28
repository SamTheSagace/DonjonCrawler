extends Character
class_name Enemy

var input_dir := Vector3(0, 0, 0)
@export var player: Player
@export var weapon_manager: WeaponManager
@onready var nav_agent = $NavigationAgent3D

enum EnemyState {
	IDLE,
	CHASE,
	ATTACK,
	HURT,
	CHARGE
}
var target = null
var target_rotation: float
var next_nav_point = null

const FACING_EPSILON := 0.1
const ATTACK_RANGE := 2.5
const CHASE_LOST_RANGE := 15.0

var current_state = EnemyState.IDLE
var moving := false
var isCharged := false

var text_info := ''
var charge_time := 1.0
var charge_timer := 0.0
var wait_timer := 0.0
var wait_time := 3.0
var rotation_Speed = FINALSPEED * 1.5

func _ready():
	super._ready()
	whoami = "enemy"
	target = player
	weapon_manager.hand_anim.animation_finished.connect(finish_animation)

func _process(delta):
	super._process(delta)
	%Info.text = "Health: %s\nStunned: %s\nStatus: %s" % [
			HEALTH_COMPONENT.health,
			is_stunned(),
			StatusType.get_statuses_string(status_inflicted),
		]
	timer_decay(delta)
	handle_nav_guide()
	if not is_stunned():
		input_dir = (next_nav_point - global_position).normalized()
	match (current_state):
		EnemyState.IDLE: _idle_state()
		EnemyState.CHASE: _chase_state()
		EnemyState.ATTACK: _attack_state()
		EnemyState.CHARGE: _charge_state()
	if HEALTH_COMPONENT.health <= 0:
		reset()

func _physics_process(delta):
	super._physics_process(delta)
	if not is_on_floor():
		velocity += get_gravity() * delta

	var movement_velocity := Vector3.ZERO
	if not is_stunned():
		self.rotation.y = lerp_angle(self.rotation.y, target_rotation, FINALSPEED * delta)
		if moving:
			if input_dir:
				movement_velocity.x = input_dir.x * FINALSPEED
				movement_velocity.z = input_dir.z * FINALSPEED
			else:
				movement_velocity.x = move_toward(velocity.x, 0, FINALSPEED)
				movement_velocity.z = move_toward(velocity.z, 0, FINALSPEED)
	velocity.x = movement_velocity.x + knockback_velocity.x
	velocity.z = movement_velocity.z + knockback_velocity.z
	move_and_slide()
	knockback_velocity = knockback_velocity.lerp(Vector3.ZERO, 8.0 * delta)

func handle_nav_guide():
	nav_agent.set_target_position(player.global_position)
	next_nav_point = nav_agent.get_next_path_position()
	target_rotation = atan2(input_dir.x, input_dir.z) + PI

func timer_decay(delta: float):
	if charge_timer > 0.0:
		charge_timer -= delta
	if wait_timer > 0.0:
		wait_timer -= delta
	if is_stunned():
		stun_timer -= delta

func reset():
	self.position = Vector3(0, self.position.y, 0)
	status_inflicted = []
	HEALTH_COMPONENT.health = HEALTH_COMPONENT.Max_health

func finish_animation(value: String):
	if value == "sword_charge":
		isCharged = true

func distance_to_player() -> float:
	return global_position.distance_to(player.global_position)

func is_facing_target() -> bool:
	return abs(target_rotation - rotation.y) <= FACING_EPSILON

func is_in_attack_range() -> bool:
	return distance_to_player() <= ATTACK_RANGE

func has_lost_target() -> bool:
	return distance_to_player() > CHASE_LOST_RANGE


func toggle_moving():
	moving = !moving

func _idle_state():
	if moving:
		toggle_moving()
	if not has_lost_target():
		current_state = EnemyState.CHASE
		return

func find_target():
	pass

func _chase_state():
	if not moving:
		toggle_moving()
	if is_in_attack_range():
		charge_timer = charge_time
		current_state = EnemyState.CHARGE
	if has_lost_target():
		current_state = EnemyState.IDLE

func _charge_state():
	if is_stunned():
		current_state = EnemyState.IDLE
	if moving:
		toggle_moving()
	if is_in_attack_range(): # Set ONCE
		if not wants_to_attack:
			wants_to_attack = true
		if charge_timer <= 0:
			charge_timer = 0.0
			wait_timer = wait_time
			current_state = EnemyState.ATTACK
	else:
		wants_to_attack = false
		current_state = EnemyState.CHASE
		return

func _attack_state():
	if is_stunned():
		current_state = EnemyState.IDLE
	if moving:
		toggle_moving()
	if wants_to_attack:
		wants_to_attack = false
	if is_in_attack_range():
		if wait_timer <= 0:
			wait_timer = 0.0
			charge_timer = charge_time
			current_state = EnemyState.CHARGE
	if not is_in_attack_range():
		current_state = EnemyState.CHASE
