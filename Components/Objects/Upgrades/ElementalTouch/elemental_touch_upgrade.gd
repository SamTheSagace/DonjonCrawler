extends BasePlayerUpgrade

@export var statusDefinition: StatusDefinition

func _apply_upgrade(_player: Player):
	var currentWeapon = _player.stateMachine.WEAPON_MANAGER.weapon_resource
	currentWeapon.statuses.append(statusDefinition)
	pass
