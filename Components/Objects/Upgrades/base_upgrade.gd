class_name BasePlayerUpgrade
extends Resource


@export var upgrade_name : String
@export var priority: int
@export var level: int = 1

func apply_upgrade(player: Player):
		# This does nothing by default
	pass
