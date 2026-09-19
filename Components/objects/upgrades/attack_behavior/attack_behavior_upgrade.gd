extends BasePlayerUpgrade
class_name AttackBehaviorPlayerUpgrade

@export var newBehavior: AttackBehavior

func _apply_upgrade(player: Player):
	if (newBehavior != null):
		var weapon = player.weapon_manager.weapon
		weapon.attack_definition = weapon.attack_definition.duplicate(true)
		weapon.attack_definition.behavior = newBehavior
