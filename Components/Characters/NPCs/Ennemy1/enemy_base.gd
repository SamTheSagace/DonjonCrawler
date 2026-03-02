extends Character
class_name Enemy

var player: Player = null
var input_dir := Vector3(0,0,0)
@export var player_path: NodePath
@onready var nav_agent = $NavigationAgent3D

enum EnemyState {
	IDLE,
	CHASE,
	ATTACK,
	HURT,
	CHARGE
}
var target = null
var target_rotation :float
var next_nav_point = null
var dir_global : Vector3
const FACING_EPSILON := 0.1
const ATTACK_RANGE := 2.0
const CHASE_LOST_RANGE := 5.0

var current_state = EnemyState.IDLE
var text_info := ''

var charge_time := 1.0
var charge_timer := 0.0
var wait_timer:= 0.0
var wait_time := 3.0

func _ready():
	super._ready()
	player = get_node(player_path)

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	self.rotation.y = lerp_angle(self.rotation.y, target_rotation, SPEED * delta)
	var movement_velocity := Vector3.ZERO
	if is_stunned:
		stun_timer -= delta
		print(stun_timer)
		if stun_timer <= 0:
			is_stunned = false
		velocity = knockback_velocity
	if input_dir:
		movement_velocity.x = input_dir.x * SPEED
		movement_velocity.z = input_dir.z * SPEED
	else:
		movement_velocity.x = move_toward(velocity.x, 0, SPEED)
		movement_velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	knockback_velocity = knockback_velocity.lerp(Vector3.ZERO, 8.0 * delta)

func _process(delta):
	if HEALTH_COMPONENT:
		%Info.text = "Health: %s\nDistance: %s\nState: %s" % [
			HEALTH_COMPONENT.health,
			nav_agent.distance_to_target(),
			EnemyState.keys()[current_state]
		]
	if current_state in [EnemyState.CHASE, EnemyState.CHARGE]:
		nav_agent.set_target_position(player.global_position)
	next_nav_point = nav_agent.get_next_path_position()
	dir_global= (next_nav_point - global_position).normalized()
	match(current_state):
		EnemyState.IDLE: _idle_state()
		EnemyState.CHASE: _chase_state()
		EnemyState.ATTACK: _attack_state()
		EnemyState.CHARGE: _charge_state()
	if HEALTH_COMPONENT.health <= 0:
		reset()

func reset():
	self.position = Vector3(0,self.position.y, 0)
	HEALTH_COMPONENT.health = HEALTH_COMPONENT.Max_health

func is_facing_target() -> bool:
	return abs(target_rotation - rotation.y) <= FACING_EPSILON

func distance_to_player() -> float:
	return global_position.distance_to(player.global_position)

func is_in_attack_range() -> bool:
	return distance_to_player() <= ATTACK_RANGE

func has_lost_target() -> bool:
	return distance_to_player()  > CHASE_LOST_RANGE

func face_next_nav_point():
	input_dir = Vector3.ZERO
	input_dir = (next_nav_point - global_position).normalized()

func face_player():
	var target_position = (next_nav_point - global_position).normalized()
	target_rotation = atan2(-target_position.x, -target_position.z)

func _idle_state():
	target = player
	input_dir = Vector3.ZERO
	if not has_lost_target():
		current_state = EnemyState.CHASE
		return

func find_target():
	pass

func _chase_state():
	face_player()
	face_next_nav_point()
	if is_in_attack_range():
		input_dir = Vector3.ZERO
		charge_timer = charge_time
		current_state = EnemyState.CHARGE
	if has_lost_target():
		current_state = EnemyState.IDLE

func _charge_state():
	face_player()
	if is_in_attack_range():
		if not wants_to_attack:
			wants_to_attack = true
		charge_timer -= get_process_delta_time()
		if charge_timer <= 0:
			current_state = EnemyState.ATTACK
	else:
		wants_to_attack = false
		current_state = EnemyState.CHASE
		return

func _attack_state():
	face_player()
	if wants_to_attack:
		wants_to_attack = false
	if is_in_attack_range():
		wait_timer = wait_time
		charge_timer -= get_process_delta_time()
		if wait_timer <=0:
			charge_timer = charge_time
			current_state = EnemyState.CHARGE
	# Otherwise chase
	current_state = EnemyState.CHASE
