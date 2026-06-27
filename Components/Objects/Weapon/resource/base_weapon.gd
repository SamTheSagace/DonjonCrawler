extends Node3D
class_name BaseWeapon

signal hit_Hitbox(target)

var handler: Character

var is_attacking := false

func _ready() -> void:
	pass

func set_attacking(value: bool) -> void:
	pass

func _on_hit_Hitbox(hitbox) -> void:
	hit_Hitbox.emit(hitbox)
