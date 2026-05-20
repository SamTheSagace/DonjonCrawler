class_name LootHurtbox
extends Node

var loot = 1
signal loot_hurtbox(target)

func _on_collision_area_entered(area):
	if area is HitboxComponent:
		var character = area.get_parent()
		if character is Player:
			loot_hurtbox.emit(character)
		self.queue_free()
