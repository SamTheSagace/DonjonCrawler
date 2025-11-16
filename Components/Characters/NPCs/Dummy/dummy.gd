extends CharacterBody3D

@export var health : HealthComponent

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var Regeneration := 2
func _ready():
	if health:
		health.damageTaken.connect(_on_damage_taken)
		%Health.text = var_to_str(health.health)

func _on_damage_taken(dmg):
	print(dmg)

func _process(delta):
	if health:
		%Health.text = var_to_str(health.health)
		if health.health < health.Max_health:
			var dif = health.Max_health - health.health
			if  dif > Regeneration:
				health.health += Regeneration
			else :
				health.health += dif
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
