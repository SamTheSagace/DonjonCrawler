extends BasePlayerUpgrade

@export var statusDefinition: StatusDefinition

func _apply_upgrade(_player: Player):
	_player.status_weapon_modifiers.append(statusDefinition)
	pass
