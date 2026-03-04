class_name WeaponManager
extends Node3D

@export var weapon_resource: WeaponResource
@export var hand_anim: HandAnimation
@export var CHARACTER : Character
signal attacking_state_changed(is_attacking: bool)
var melee_weapon: MeleeWeapon
var ranged_weapon: WeaponBase
var attack_finished:= true
var hand: Node3D

func _ready() -> void:
	assert(hand_anim != null)
	assert(weapon_resource != null)
	hand_anim.animation_finished.connect(finish_animation)
	await hand_anim.ready
	hand = hand_anim.hand
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
	hand.add_child(melee_weapon)

func update_ranged_weapon():
	clean_up_weapon()
	ranged_weapon = weapon_resource.world_model.instantiate()
	hand.add_child(ranged_weapon)

func clean_up_weapon():
	if hand.has_node("MeleeWeapon"):
		hand.get_node("MeleeWeapon").queue_free()
	if hand.has_node("RangedWeapon"):
		hand.get_node("RangedWeapon").queue_free()

func go_to_idle():
	if(weapon_resource):
		hand_anim._on_idleInput()

func start_charge():
	hand_anim._on_chargeInput(weapon_resource)

func start_attack():
	attack_finished = false
	if(weapon_resource):
		emit_signal("attacking_state_changed", true)
		hand_anim._on_attackInput(weapon_resource)

func finish_animation(value:String):
	if value == "sword_slash":
		attack_finished = true
		emit_signal("attacking_state_changed", false)

func start_parry():
	if(weapon_resource):
		hand_anim._on_parryInput(weapon_resource)

func attack_Hit(hitbox):
	print("should damage")
	var attack = Attack.new()
	attack.attacker_position = CHARACTER.global_position
	attack.knockback = weapon_resource.knockback
	attack.base_damage = weapon_resource.damage
	hitbox.damage(attack)
