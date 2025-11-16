class_name GhostArmUpgrade
extends BasePlayerUpgrade

@export var ghost_Model: PackedScene
@export var ghostSword : PackedScene
@export var ghostBow : PackedScene
@export var ghostSpear : PackedScene


var weaponManager : WeaponManager
var ghostWeaponManager : WeaponManager
var ghost : CharacterBody3D

func apply_upgrade(player: Player):
	for child in player.get_children():
		if child is WeaponManager:
			weaponManager = child
	ghost = ghost_Model.instantiate()
	for child in ghost.get_children():
		if child is WeaponManager:
			ghostWeaponManager = child
	player.attackInput.connect(Callable(ghost, "_on_player_attack"))
	ghostWeaponManager.weapon_resource =  weaponManager.weapon_resource.duplicate()
	ghostWeaponManager.weapon_resource.damage = weaponManager.weapon_resource.damage * .5
	if ghostWeaponManager.weapon_resource.weapon_type == WeaponType.Type.MELEE:
		ghostWeaponManager.weapon_resource.world_model = ghostSword
	player.add_child(ghost)
	ghost.global_position = player.global_position
	
