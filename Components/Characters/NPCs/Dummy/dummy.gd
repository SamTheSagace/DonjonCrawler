extends Character

@export var Regeneration := 2
func _ready():
	if HEALTH_COMPONENT:
		HEALTH_COMPONENT.damageTaken.connect(_on_damage_taken)
		%Health.text = var_to_str(HEALTH_COMPONENT.health)

func _on_damage_taken(dmg):
	print(dmg)

func _process(delta):
	if HEALTH_COMPONENT:
		%Health.text = var_to_str(HEALTH_COMPONENT.health)
		if HEALTH_COMPONENT.health < HEALTH_COMPONENT.Max_health:
			var dif = HEALTH_COMPONENT.Max_health - HEALTH_COMPONENT.health
			if  dif > Regeneration:
				HEALTH_COMPONENT.health += Regeneration
			else :
				HEALTH_COMPONENT.health += dif

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
