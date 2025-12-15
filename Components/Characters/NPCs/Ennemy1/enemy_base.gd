class_name Enemy
extends Character

var player: Player = null
var input_dir := Vector3(0,0,0)
@export var player_path: NodePath
@onready var nav_agent = $NavigationAgent3D

enum EnemyState {
	IDLE,
	CHASE,
	ATTACK,
	HURT
}
var target = null
var current_state = EnemyState.IDLE
var text_info := ''
var next_nav_point = null
var dir_global : Vector3
var target_rotation :float

func _ready():
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
	if health:
		%Info.text = "Health: %s\nDistance: %s\nState: %s" % [
			health.health,
			nav_agent.distance_to_target(),
			current_state
		]
	nav_agent.set_target_position(player.global_position)
	next_nav_point = nav_agent.get_next_path_position()
	dir_global= (next_nav_point - global_position).normalized()
	match(current_state):
		EnemyState.IDLE: _idle_state()
		EnemyState.CHASE: _chase_state()
		EnemyState.ATTACK: _attack_state()

func _idle_state():
	#$AnimationPlayer.play("idle")
	target = player
	if target != null:
		current_state = EnemyState.CHASE
		return

func find_target():
	pass

func _chase_state():
	input_dir = (next_nav_point - self.global_position).normalized()
	target_rotation = atan2(-input_dir.x, -input_dir.z)
	if abs(nav_agent.distance_to_target()) < 2:
		input_dir = Vector3(0,0,0)
		current_state = EnemyState.ATTACK
	#print(nav_agent.distance_to_target())
	pass

func _attack_state():
	var target = (next_nav_point - self.global_position).normalized()
	target_rotation = atan2(-target.x, -target.z)
	if abs(nav_agent.distance_to_target()) > 5:
		current_state = EnemyState.CHASE
	pass
