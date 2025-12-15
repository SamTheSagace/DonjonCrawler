class_name MeleeWeapon
extends Weapon

#var weapon_data : WeaponResource 
@onready var hurtbox : WeaponHurtbox = $WeaponHitbox

func _ready() -> void:
	hurtbox.hit_Hitbox.connect(_on_hit_Hitbox)
	#pass # Replace with function body.
#


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
