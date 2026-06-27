class_name WeaponHurtbox
extends Node

signal hit_Hitbox(target: HitboxComponent)

func _on_collision_area_entered(area):
	if area is HitboxComponent:
		hit_Hitbox.emit(area)
	 # Replace with function body.
