class_name Ennemy
extends Character

enum EnemyState {
	IDLE,
	CHASE,
	ATTACK,
	HURT
}

var current_state = EnemyState.IDLE

func _ready():
	if health:
		%Health.text = var_to_str(health.health)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_act&ion_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _process(delta):
	#match(current_state):
		#EnemyState.IDLE: _idle_state()
		#EnemyState.CHASE: _chase_state()
		#EnemyState.ATTACK: _attack_state()
	if health:
		%Health.text = var_to_str(health.health)

#func _idle_state():
	#$AnimationPlayer.play("idle")
		#target = find_target()
	#if target != null:
		#current_state = EnemyState.CHASE
		#return
		#
#func find_target():
	#pass
#
#func _chase_state():
	#pass
	#
#func _attack_state():
	#pass
	#
#
