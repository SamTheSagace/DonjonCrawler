class_name Weapon_Manager
extends Node3D

@export var player : CharacterBody3D
#@export var bullet_raycast : RayCast3D

@export var weapon_data: WeaponResource
@export var view_model_container: Node3D
@export var world_model_container: Node3D

var current_weapon_view_model : Node3D
var current_weapon_world_model : Node3D
signal attack_Animation(new_value)

func update_weapon_model() -> void:
	if weapon_data != null:		
		if view_model_container and weapon_data.view_model:
			current_weapon_view_model = weapon_data.view_model.instantiate()
			view_model_container.add_child(current_weapon_view_model)
		if world_model_container and weapon_data.world_model:
			current_weapon_world_model = weapon_data.world_model.instantiate()
			world_model_container.add_child(current_weapon_world_model)
			current_weapon_world_model.weapon_data = weapon_data

func _ready() -> void:
	player.attackInput.connect(_on_attackInput)
	update_weapon_model()

func _process(delta):
	
	pass

func _on_attackInput():
	var weapon = current_weapon_world_model.weapon_data
	if(weapon):
		emit_signal("attack_Animation", weapon.weapon_type)
		if(weapon.weapon_type == WeaponType.Type.RANGED):
			print("bang")
	pass
