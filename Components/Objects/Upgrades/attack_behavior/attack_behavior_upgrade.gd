extends BasePlayerUpgrade
class_name AttackBehaviorPlayerUpgrade

@export var newAttackBehavior: PackedScene


func _apply_upgrade(player: Player):
	assert(newAttackBehavior.instantiate() is AttackHitboxBehavior)
	var weapon = player.WEAPON_MANAGER.weapon
	weapon.attack_scene = newAttackBehavior
