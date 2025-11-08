class_name Weapon
extends Node

#var weapon_data : WeaponResource 

signal hit_Hitbox(target)

@onready var hitbox : WeaponHurtbox = $WeaponHitbox

func _ready() -> void:
	hitbox.hit_Hitbox.connect(_on_hit_Hitbox)
	#pass # Replace with function body.
#
func _on_hit_Hitbox(hitbox):
	emit_signal("hit_Hitbox", hitbox)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
