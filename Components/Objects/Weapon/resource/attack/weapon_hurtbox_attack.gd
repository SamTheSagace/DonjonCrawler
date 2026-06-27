extends Node3D
class_name WeaponHurtboxAttack

signal hit_Hitbox(target: HitboxComponent)

var follow_weapon := false

@onready var hurtbox: WeaponHurtbox = $WeaponHurtbox

func _ready() -> void:
	hurtbox.hit_Hitbox.connect(_on_hit_Hitbox)

func _add_self(weapon: BaseWeapon):
	weapon.add_child(self)

func stop_following():
	follow_weapon = false

func start_decay_timer():
	await get_tree().create_timer(0.5).timeout
	queue_free()


func _on_hit_Hitbox(hitbox: HitboxComponent) -> void:
	hit_Hitbox.emit(hitbox)
