class_name WeaponManager
extends Node3D

@export var character: Character

@export var weapon_resource: WeaponResource
@export var view_model_container: Node3D
@export var world_model_container: Node3D

var melee_instance : MeleeWeapon
var ranged_instance : WeaponBase

signal attack_Animation(weapon_ressource)

func update_weapon_model(weapon: WeaponBase) -> void:
	if weapon_resource != null:
		if view_model_container and weapon_resource.view_model:
			view_model_container.add_child(weapon_resource.view_model.instantiate())
		if world_model_container and weapon_resource.world_model:
			weapon = weapon_resource.world_model.instantiate()
			weapon.hit_Hitbox.connect(attack_Hit)
			world_model_container.add_child(weapon)

func _ready() -> void:
	if(character):
		character.attackInput.connect(_on_attackInput)	
	if weapon_resource != null:
		match(weapon_resource.weapon_type):
			WeaponType.Type.MELEE: update_weapon_model(melee_instance)
			WeaponType.Type.RANGED: update_weapon_model(ranged_instance)
			_: print("unknown type")
 
func _process(delta):
	pass
	
func _on_attackInput():
	if(weapon_resource):
		emit_signal("attack_Animation", weapon_resource)

func attack_Hit(hitbox):
	var attack = Attack.new()
	attack.attack_Damage = weapon_resource.damage
	hitbox.damage(attack)
