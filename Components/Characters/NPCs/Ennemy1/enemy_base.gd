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

func _ready():
	super._ready()
	player = get_node(player_path)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	var direction = input_dir
	self.rotation.y = lerp_angle(self.rotation.y, target_rotation, SPEED*delta)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

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
		self.queue_free()

func is_facing_target() -> bool:
	return abs(target_rotation - rotation.y) <= FACING_EPSILON
	
func is_in_attack_range() -> bool:
	return nav_agent.distance_to_target() <= ATTACK_RANGE

func has_lost_target() -> bool:
	return nav_agent.distance_to_target() > CHASE_LOST_RANGE

func face_next_nav_point():
	input_dir = Vector3.ZERO
	input_dir = (next_nav_point - global_position).normalized()
	target_rotation = atan2(-input_dir.x, -input_dir.z)


func _idle_state():
	target = player
	if target != null:
		current_state = EnemyState.CHASE
		return

func find_target():
	pass

func _chase_state():
	face_next_nav_point()
	if is_in_attack_range():
		input_dir = Vector3.ZERO
		charge_timer = charge_time
		current_state = EnemyState.CHARGE

func _charge_state():
	face_next_nav_point()
	if has_lost_target():
		wants_to_attack = false
		current_state = EnemyState.CHASE
		return
	if is_facing_target():
		if not wants_to_attack:
			wants_to_attack = true
		charge_timer -= get_process_delta_time()
		if charge_timer <= 0:
			current_state = EnemyState.ATTACK

func _attack_state():
	if wants_to_attack:
		wants_to_attack = false
	# If still close, go back to charging (combo / loop)
	if is_in_attack_range():
		charge_timer = charge_time
		current_state = EnemyState.CHARGE
		return
	# Otherwise chase
	if has_lost_target():
		current_state = EnemyState.CHASE
