extends Node3D
class_name SpawnedAttack

var timer := 1.0

signal hit_Hitbox(target)

@onready var hurtbox: WeaponHurtbox = %WeaponHitbox


func _ready() -> void:
	hurtbox.hit_Hitbox.connect(_on_hit_Hitbox)


func _on_hit_Hitbox(hitbox):
	hit_Hitbox.emit(hitbox)
