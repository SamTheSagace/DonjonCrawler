extends Node3D
@export var upgrade: BasePlayerUpgrade
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Label3D.text = upgrade.upgrade_name
	for child in get_children():
		if child is LootHurtbox:
			child.loot_hurtbox.connect(_on_touch_loot)
	pass # Replace with function body.

func _on_touch_loot(character: Player):
	character.add_upgrade(upgrade)
	print(character.upgrades)
	print("upgraded with ", upgrade.upgrade_name)
	self.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
