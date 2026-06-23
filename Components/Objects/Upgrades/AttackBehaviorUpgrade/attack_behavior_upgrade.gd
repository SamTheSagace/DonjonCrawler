extends BasePlayerUpgrade
class_name AttackBehaviorPlayerUpgrade

@export var newAttackBehavior: GDScript


func _apply_upgrade(player: Player):
	var weapon = player.WEAPON_MANAGER.weapon
	weapon.attack_scene.set_script(newAttackBehavior)
