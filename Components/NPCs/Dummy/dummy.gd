extends CharacterBody3D

@export var health : HealthComponent


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready():
	if health:
		$Label3D.text = var_to_str(health.health)


func _process(delta):
	if health:
		$Label3D.text = var_to_str(health.health)
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
