extends Node
class_name Weapon

signal hit_Hitbox(target)

func _on_hit_Hitbox(hitbox):
	emit_signal("hit_Hitbox", hitbox)
