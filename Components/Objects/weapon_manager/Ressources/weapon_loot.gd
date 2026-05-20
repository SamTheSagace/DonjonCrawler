@tool
extends Node3D

@export var weapon_ressource: WeaponResource
@export var loot_hurtbox: LootHurtbox
var time_in_seconds = .2

func _ready() -> void:
	assert(loot_hurtbox != null)
	assert(weapon_ressource != null)
	%Label3D.text = weapon_ressource.name
	loot_hurtbox.loot_hurt.connect(_on_touch_loot)
	self.add_child(weapon_ressource.world_model.instantiate())
	pass # Replace with function body.


func _on_touch_loot(character: Player):
	var weapon_manager = character.stateMachine.WEAPON_MANAGER
	weapon_manager.weapon_resource = weapon_ressource.duplicate(true)
	weapon_manager.weapon_match()
	self.global_position += Vector3(0, 1, 0)
	await get_tree().create_timer(time_in_seconds).timeout
	self.queue_free()
