class_name GhostArmUpgrade
extends BasePlayerUpgrade

@export var ghost_arm: PackedScene
@export var ghostSword: PackedScene
@export var ghostBow: PackedScene
@export var ghostSpear: PackedScene

var ghost: GhostArm


func _apply_upgrade(player: Player):
	var player_weapon_manager = player.WEAPON_MANAGER
	ghost = ghost_arm.instantiate()
	assert(ghost is GhostArm)
	player_weapon_manager.attack_started.connect(ghost._on_signal_attack)
	ghost.ghostWeaponManager.weapon_resource = player_weapon_manager.weapon_resource.duplicate(true)
	ghost.ghostWeaponManager.weapon_resource.damage *= 0.5
	ghost.ghostWeaponManager.weapon_resource.knockback = 0
	if ghost.ghostWeaponManager.weapon_resource.weapon_superType == WeaponParam.SuperType.MELEE:
		ghost.ghostWeaponManager.weapon_resource.scene_weapon = ghostSword
	player.add_child(ghost)
	ghost.global_position = player.global_position
