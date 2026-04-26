extends BasePlayerUpgrade

@export var element: ElementList.Type

func apply_upgrade(player: Player):
	var weaponManager = player.stateMachine.WEAPON_MANAGER
	pass
