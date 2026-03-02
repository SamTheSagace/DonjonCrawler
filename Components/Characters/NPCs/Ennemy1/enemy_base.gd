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
const FACING_EPSILON := 0.1
const ATTACK_RANGE :=3.0
const CHASE_LOST_RANGE := 6.0

var current_state = EnemyState.IDLE
var text_info := ''
var stunned := false
var moving := false
var charge_time := 1.0
var charge_timer := 0.0
var Rotation_Speed = SPEED * 1.5
func _ready():
	super._ready()
	player = get_node(player_path)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta	
	if not stunned: 
		self.rotation.y = lerp_angle(self.rotation.y, target_rotation, SPEED*delta)
		if moving : 
			if input_dir:
				velocity.x = input_dir.x * SPEED
				velocity.z = input_dir.z * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
			move_and_slide()

func _process(delta):
	if HEALTH_COMPONENT:
		%Info.text = "Health: %s\nDistance: %s\nState: %s" % [
			HEALTH_COMPONENT.health,
			wants_to_attack,
			EnemyState.keys()[current_state]
		]
	nav_agent.set_target_position(player.global_position)
	next_nav_point = nav_agent.get_next_path_position()
	target_rotation = atan2(input_dir.x, input_dir.z)+ PI
	input_dir = (next_nav_point - global_position).normalized()
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

func toggle_moving():
	moving = !moving

func _idle_state():
	if moving:
		toggle_moving()
	target = player
	if target != null:
		current_state = EnemyState.CHASE
		return

func find_target():
	pass

func _chase_state():
	if not moving: 
		toggle_moving()
	if is_in_attack_range():
		input_dir = Vector3.ZERO
		charge_timer = charge_time
		current_state = EnemyState.CHARGE
	if has_lost_target():
		current_state = EnemyState.IDLE

func _charge_state():
	if moving:
		toggle_moving()
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
	if moving:
		toggle_moving()
	if wants_to_attack:
		wants_to_attack = false	
	if is_in_attack_range():
		charge_timer = charge_time
		current_state = EnemyState.CHARGE
		return
	# Otherwise chase
	if not is_in_attack_range():
		current_state = EnemyState.CHASE
