extends Node3D
class_name WeaponHurtboxAttack

signal hit_Hitbox(target: HitboxComponent)
var decay_timer := 1
var follow_weapon := false

@onready var hurtbox: WeaponHurtbox = $WeaponHurtbox

func _ready() -> void:
	hurtbox.hit_Hitbox.connect(_on_hit_Hitbox)


func stop_following():
	follow_weapon = false

func start_decay_timer():
	await get_tree().create_timer(decay_timer).timeout
	queue_free()


func _on_hit_Hitbox(hitbox: HitboxComponent) -> void:
	hit_Hitbox.emit(hitbox)
