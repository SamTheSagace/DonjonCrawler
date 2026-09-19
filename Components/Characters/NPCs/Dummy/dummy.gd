extends Character

@export var Regeneration := 2
func _ready():
	super._ready()
	if health_component:
		health_component.damageTaken.connect(_on_damage_taken)
		%Health.text = var_to_str(health_component.health)

func _on_damage_taken(_dmg):
	pass

func _process(_delta):
	if health_component:
		%Health.text = var_to_str(health_component.health)
		if health_component.health < health_component.Max_health:
			var dif = health_component.Max_health - health_component.health
			if dif > Regeneration:
				health_component.health += Regeneration
			else:
				health_component.health += dif

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
