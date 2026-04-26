extends Node
class_name WeaponBase

signal hit_Hitbox(target)

func _on_hit_Hitbox(hitbox):
	hit_Hitbox.emit(hitbox)
