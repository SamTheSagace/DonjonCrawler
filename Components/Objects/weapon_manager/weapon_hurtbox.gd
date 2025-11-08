class_name WeaponHurtbox
extends Node

signal hit_Hitbox(target)

func _on_collision_area_entered(area):
	if area is HitboxComponent:
		var hitbox: HitboxComponent = area
		emit_signal("hit_Hitbox", hitbox)
	 # Replace with function body.
