extends Character
class_name Enemy

var input_dir := Vector3(0,0,0)
@export var player: Player 
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
var wait_timer:= 0.0
var wait_time := 3.0
var Rotation_Speed = SPEED * 1.5
func _ready():
	super._ready()
	target = player

func _physics_process(delta):
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
	if charge_timer > 0.0:
		charge_timer -= delta
	if wait_timer > 0.0:
		wait_timer -= delta
	if HEALTH_COMPONENT:
		%Info.text = "Health: %s\nStunned: %s\nState: %s" % [
			HEALTH_COMPONENT.health,
			charge_timer,
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

func toggle_moving():
	moving = !moving

func _idle_state():
	if moving:
		toggle_moving()
	input_dir = Vector3.ZERO
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
	if moving:
		toggle_moving()
	if is_in_attack_range():  # Set ONCE
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
	if stunned:
		current_state = EnemyState.IDLE
	if moving:
		toggle_moving()
	if wants_to_attack:
		wants_to_attack = false
	if is_in_attack_range():
		if wait_timer <=0:
			wait_timer = 0.0
			charge_timer = charge_time
			current_state = EnemyState.CHARGE
	if not is_in_attack_range():
		current_state = EnemyState.CHASE
