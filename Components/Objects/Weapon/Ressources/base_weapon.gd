extends Node3D
class_name BaseWeapon

signal hit_Hitbox(target)

var handler: Character
var attack_scene: AttackHitboxBehavior
var is_attacking := false

@export var transformPoint: Node3D
@export var hitbox_scene: PackedScene


func set_attacking(value: bool) -> void:
	is_attacking = value
	if value:
		var context = AttackHitboxContext.new(handler, self, hitbox_scene)
		attack_scene = AttackHitboxBehavior.create(context)
		attack_scene.hit_Hitbox.connect(_on_hit_Hitbox)
	else:
		if attack_scene:
			attack_scene.expire()


func _on_hit_Hitbox(hitbox) -> void:
	hit_Hitbox.emit(hitbox)
