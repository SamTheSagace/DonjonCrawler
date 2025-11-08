class_name WeaponManager
extends Node3D

@export var character: CharacterBody3D

@export var weapon_resource: WeaponResource
@export var view_model_container: Node3D
@export var world_model_container: Node3D

var model_instance : Weapon

signal attack_Animation(new_value)

func update_weapon_model() -> void:
	if weapon_resource != null:
		if view_model_container and weapon_resource.view_model:
			view_model_container.add_child(weapon_resource.view_model.instantiate())
		if world_model_container and weapon_resource.world_model:
			model_instance = weapon_resource.world_model.instantiate()
			model_instance.hit_Hitbox.connect(attack)
			world_model_container.add_child(model_instance)

func _ready() -> void:
	if(character.attackInput):
		character.attackInput.connect(_on_attackInput)
	update_weapon_model()

func _process(delta):
	
	pass

func attack(hitbox):
	var attack = Attack.new()
	attack.attack_Damage = weapon_resource.damage
	hitbox.damage(attack)

func _on_attackInput():
	if(weapon_resource):
		emit_signal("attack_Animation", weapon_resource)
