@tool
extends Node3D

@export var upgrade: BasePlayerUpgrade
@export var loot_hurtbox: LootHurtbox
var time_in_seconds = .2

func _ready() -> void:
	%Label3D.text = upgrade.upgrade_name
	assert(loot_hurtbox != null)
	loot_hurtbox.loot_hurt.connect(_on_touch_loot)
	pass # Replace with function body.


func _on_touch_loot(character: Player):
	character.add_upgrade(upgrade)
	self.global_position += Vector3(0, 1, 0)
	await get_tree().create_timer(time_in_seconds).timeout
	self.queue_free()

func _process(_delta: float) -> void:
	pass
