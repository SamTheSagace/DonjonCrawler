class_name GhostArmUpgrade
extends BasePlayerUpgrade

@export var ghost_arm: PackedScene
@export var ghostSword: PackedScene
@export var ghostBow: PackedScene
@export var ghostSpear: PackedScene


var ghostWeaponManager: WeaponManager

var ghost: GhostArm

func _apply_upgrade(player: Player):
	var weaponManager = player.stateMachine.WEAPON_MANAGER
	ghost = ghost_arm.instantiate()
	for child in ghost.get_children():
		if child is WeaponManager:
			ghostWeaponManager = child
	ghost.ghostWeaponManager = ghostWeaponManager
	weaponManager.attack_started.connect(ghost._on_signal_attack)
	ghostWeaponManager.weapon_resource = weaponManager.weapon_resource.duplicate()
	ghostWeaponManager.weapon_resource.damage *= 0.5
	ghostWeaponManager.weapon_resource.knockback = 0
	if ghostWeaponManager.weapon_resource.weapon_type == WeaponParameter.Type.MELEE:
		ghostWeaponManager.weapon_resource.world_model = ghostSword
	player.add_child(ghost)
	ghost.global_position = player.global_position
