class_name GhostArmUpgrade
extends BasePlayerUpgrade

@export var ghost_arm: PackedScene
@export var ghostSword: PackedScene
@export var ghostBow: PackedScene
@export var ghostSpear: PackedScene

var ghost: GhostArm


func _apply_upgrade(player: Player):
	ghost = ghost_arm.instantiate()
	assert(ghost is GhostArm)
	player.WEAPON_ACTION.attack_started.connect(ghost._on_signal_attack)
	ghost.weapon_manager.weapon_equipped.connect(_on_ghost_weapon_equipped.bind(player))
	ghost.weapon_manager.weapon_resource = player.WEAPON_MANAGER.weapon_resource.duplicate(true)
	ghost.weapon_manager.weapon_resource.damage *= 0.5
	ghost.weapon_manager.weapon_resource.knockback = 0
	if ghost.weapon_manager.weapon_resource.weapon_superType == WeaponParam.SuperType.MELEE:
		ghost.weapon_manager.weapon_resource.scene_weapon = ghostSword
	player.add_child(ghost)
	ghost.global_position = player.global_position

func _on_ghost_weapon_equipped(_weapon: BaseWeapon, player: Player):
	ghost.weapon_action.CHARACTER = player
