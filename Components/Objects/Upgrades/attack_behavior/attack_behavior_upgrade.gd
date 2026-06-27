extends BasePlayerUpgrade
class_name AttackBehaviorPlayerUpgrade

@export var newBehavior: AttackBehavior

func _apply_upgrade(player: Player):
	if (newBehavior != null):
		player.WEAPON_MANAGER.weapon.attack_definition.behavior = newBehavior
