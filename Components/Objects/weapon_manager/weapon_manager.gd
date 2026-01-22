class_name WeaponManager
extends Node3D

@export var character: Character

@export var weapon_resource: WeaponResource
@export var view_model_container: Node3D
@export var world_model_container: Node3D
var world_hand_anim: WorldHandAnimation

signal attack_Animation(weapon_resource)
signal isAttacking(bool)
var melee_weapon: MeleeWeapon 
var ranged_weapon: WeaponBase

func _ready() -> void:
	if %WorldModelAnimation:
			world_hand_anim = %WorldModelAnimation
			world_hand_anim.animation_finished.connect(finish_attack)
	if character != null:
		character.attackInput.connect(_on_attackInput)
	if weapon_resource != null:
		weapon_match()

func weapon_match():
	if view_model_container and weapon_resource.view_model:
		view_model_container.add_child(weapon_resource.view_model.instantiate())
	if world_model_container and weapon_resource.world_model:
		match(weapon_resource.weapon_type):
				WeaponType.Type.MELEE: update_melee_weapon()
				WeaponType.Type.RANGED: update_ranged_weapon()
				_: print("unknown type") 

func update_melee_weapon():
	clean_up_weapon()
	melee_weapon = weapon_resource.world_model.instantiate()
	melee_weapon.hit_Hitbox.connect(attack_Hit)
	isAttacking.connect(melee_weapon.set_attacking)
	world_model_container.add_child(melee_weapon)
	
func update_ranged_weapon():
	clean_up_weapon()
	ranged_weapon = weapon_resource.world_model.instantiate()
	world_model_container.add_child(ranged_weapon)

func clean_up_weapon():
	world_model_container.remove_child(melee_weapon)
	world_model_container.remove_child(ranged_weapon)

func finish_attack():
	emit_signal("isAttacking", false)

func _on_attackInput():
	if(weapon_resource):
		emit_signal("isAttacking", true)
		emit_signal("attack_Animation", weapon_resource)

func attack_Hit(hitbox):
	var attack = Attack.new()
	attack.attack_Damage = weapon_resource.damage
	hitbox.damage(attack)
