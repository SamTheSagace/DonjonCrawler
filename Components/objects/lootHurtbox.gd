class_name LootHurtbox
extends Area3D

var loot = 1
signal loot_hurt(target: Character)

func _on_collision_area_entered(area):
	if area is HitboxComponent:
		var character = area.get_parent()
		if character is Player:
			loot_hurt.emit(character)
