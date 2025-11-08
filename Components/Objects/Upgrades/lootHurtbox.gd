class_name LootHurtbox
extends Node

var loot = 1
signal loot_hurtbox(target)

func _on_collision_area_entered(area):
	if area is HitboxComponent:
		var character = area.get_parent()
		if character is Player:
			emit_signal("loot_hurtbox",character)
	 # Replace with function body.
