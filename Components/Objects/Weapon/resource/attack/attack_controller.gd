extends Node3D
class_name AttackController

signal hit_Hitbox(target: HitboxComponent)

var current_behavior: AttackBehavior
var current_hitbox: WeaponHurtboxAttack


func start_attack(definition: AttackDefinition, weapon: BaseWeapon):
	current_behavior = definition.behavior
	current_hitbox = definition.hitbox_scene.instantiate()
	current_hitbox.hit_Hitbox.connect(_on_hit)
	current_behavior._on_start(current_hitbox, weapon, self)


func finish_attack():
	if current_behavior and current_hitbox:
		current_behavior._on_finish(current_hitbox)
	current_hitbox = null
	current_behavior = null

func _on_hit(target: HitboxComponent):
	hit_Hitbox.emit(target)
	pass

func tick(delta: float, weapon: BaseWeapon) -> void:
	if(current_behavior != null):
		current_behavior.tick(current_hitbox,weapon,delta)
		#for b in current_behavior:
			#b.tick(delta)
