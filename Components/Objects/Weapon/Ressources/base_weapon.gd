extends Node3D
class_name BaseWeapon

signal hit_Hitbox(target)

var handler: Character
var current_attack: AttackHitboxBehavior
var is_attacking := false
var attack_script: GDScript

@export var transformPoint: Node3D 
@export var hitbox_scene: PackedScene



func set_attacking(value: bool) -> void:
	is_attacking = value
	if value:
		current_attack = AttackHitboxBehavior.create(AttackHitboxContext.new(
			handler,
			get_tree().root,
			self,
			hitbox_scene
		))
		current_attack.hit_Hitbox.connect(_on_hit_Hitbox)
	else:
		if current_attack:
			current_attack.expire()


func _on_hit_Hitbox(hitbox) -> void:
	hit_Hitbox.emit(hitbox)
