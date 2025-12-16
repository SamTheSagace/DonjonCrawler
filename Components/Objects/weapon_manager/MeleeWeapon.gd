class_name MeleeWeapon
extends WeaponBase

#var weapon_data : WeaponResource 
@onready var hurtbox : WeaponHurtbox = $WeaponHitbox

func _ready() -> void:
	hurtbox.hit_Hitbox.connect(_on_hit_Hitbox)
	#pass # Replace with function body.

var is_attacking := false

func set_attacking(value:bool) -> void:
	is_attacking = value

func _on_hit_Hitbox(hitbox):
	if is_attacking :
		emit_signal("hit_Hitbox", hitbox)
