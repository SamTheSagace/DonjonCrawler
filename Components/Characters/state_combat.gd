extends State
class_name StateCombat
var weapon_manager: WeaponManager
var weapon_action: WeaponAction
var health_component: HealthComponent

func _ready() -> void:
	pass

func resolve_on_hit(_attack: Attack):
	pass
