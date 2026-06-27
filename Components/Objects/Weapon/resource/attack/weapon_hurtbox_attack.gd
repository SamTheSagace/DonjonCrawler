extends Node3D
class_name WeaponHurtboxAttack

signal hit_Hitbox(target: HitboxComponent)
@onready var hurtbox = $WeaponHurtbox

func _ready() -> void:
	hurtbox.hit_Hitbox.connect(_on_hit_Hitbox)


func _on_hit_Hitbox(hitbox: HitboxComponent) -> void:
	hit_Hitbox.emit(hitbox)
