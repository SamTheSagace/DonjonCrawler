class_name WeaponManager
extends Node3D

@export var weapon_resource: WeaponResource
@export var hand_anim: HandAnimation

signal attacking_state_changed(is_attacking: bool)

var melee_weapon: MeleeWeapon
var ranged_weapon: WeaponBase
var attack_finished:= true

func _ready() -> void:
	if hand_anim != null:
		hand_anim.animation_finished.connect(finish_attack)
	if weapon_resource != null:
		weapon_match()
func weapon_match():
	if hand_anim and weapon_resource.world_model:
		match(weapon_resource.weapon_type):
				WeaponType.Type.MELEE: update_melee_weapon()
				WeaponType.Type.RANGED: update_ranged_weapon()
				_: print("unknown type")

func update_melee_weapon():
	clean_up_weapon()
	melee_weapon = weapon_resource.world_model.instantiate()
	melee_weapon.hit_Hitbox.connect(attack_Hit)
	attacking_state_changed.connect(melee_weapon.set_attacking)
	hand_anim.add_child(melee_weapon)

func update_ranged_weapon():
	clean_up_weapon()
	ranged_weapon = weapon_resource.world_model.instantiate()
	hand_anim.add_child(ranged_weapon)

func clean_up_weapon():
	if hand_anim.has_node("MeleeWeapon"):
		hand_anim.get_node("MeleeWeapon").queue_free()
	if hand_anim.has_node("RangedWeapon"):
		hand_anim.get_node("RangedWeapon").queue_free()

func go_to_idle():
	if(weapon_resource):
		emit_signal("reset_animation")

func start_charge():
	pass
func start_attack():
	attack_finished = false
	if(weapon_resource):
		emit_signal("attacking_state_changed", true)
		hand_anim._on_attackInput(weapon_resource)

func finish_attack(value:String):
	attack_finished = true
	print(value)
	emit_signal("attacking_state_changed", false)

func start_parry():
	if(weapon_resource):
		hand_anim._on_parryInput(weapon_resource)

func attack_Hit(hitbox):
	var attack = Attack.new()
	attack.attack_Damage = weapon_resource.damage
	hitbox.damage(attack)
