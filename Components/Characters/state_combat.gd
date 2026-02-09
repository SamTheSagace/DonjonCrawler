extends State
class_name StateCombat
var weapon_manager : WeaponManager
var health_component: HealthComponent

func _ready() -> void:
	assert(weapon_manager !=null && health_component !=null)

func resolve_on_hit(attack: Attack):
	pass
