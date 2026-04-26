class_name MeleeWeapon
extends WeaponBase

#var weapon_data : WeaponResource
@onready var hurtbox : WeaponHurtbox = $WeaponHitbox
var is_attacking := false

func _ready() -> void:
	hurtbox.hit_Hitbox.connect(_on_hit_Hitbox)

func set_attacking(value:bool) -> void:
	is_attacking = value

func _on_hit_Hitbox(hitbox):
	if is_attacking :
		hit_Hitbox.emit(hitbox)
