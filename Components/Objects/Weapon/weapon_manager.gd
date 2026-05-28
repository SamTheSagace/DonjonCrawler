extends Node3D
class_name WeaponManager

@export var weapon_resource: WeaponResource
@export var hand_anim: HandAnimation
@export var CHARACTER: Character
signal attack_started(is_attack: bool)

var weapon: BaseWeapon
var attack_finished := true
var parry_finished := true
var hand: Node3D

func _ready() -> void:
	assert(hand_anim != null)
	assert(weapon_resource != null)
	weapon_resource = weapon_resource.duplicate(true)
	hand_anim.animation_finished.connect(finish_animation)
	await hand_anim.ready
	hand = hand_anim.hand
	weapon_match()

func weapon_match():
	assert(weapon_resource.weapon_type != null)
	match (weapon_resource.weapon_type):
		WeaponType.List.MELEE: update_weapon()
		WeaponType.List.RANGED: update_weapon()
		_: print("unknown type")

func update_weapon():
	clean_up_weapon()
	weapon = weapon_resource.instantiate_weapon()
	weapon.hit_Hitbox.connect(attack_Hit)
	hand.add_child(weapon)

func clean_up_weapon():
	if hand.has_node("Weapon"):
		print("clean up worked")
		hand.get_node("Weapon").queue_free()

func go_to_idle():
	hand_anim._on_idleInput()

func start_charge():
	attack_started.emit(false)
	hand_anim._on_chargeInput(weapon_resource)

func start_attack():
	attack_finished = false
	attack_started.emit(true)
	weapon.set_attacking(true)
	hand_anim._on_attackInput(weapon_resource)

func finish_animation(value: String):
	if value == "sword_slash":
		attack_finished = true
		weapon.set_attacking(false)
	if value == "sword_parry":
		parry_finished = true

func start_parry():
	parry_finished = false
	if (hand_anim.animation.current_animation != "RESET"):
		weapon.set_attacking(false)
		hand_anim._on_parryInput(weapon_resource)
		return
	hand_anim._on_parryInput(weapon_resource)

func attack_Hit(hitbox: HitboxComponent):
	var attack = Attack.new()
	attack.attacker = CHARACTER
	var statuses = weapon_resource.statuses
	if (statuses.size() > 0):
		for status: StatusDefinition in statuses:
			if (status == null):
				statuses.erase(status)
			else:
				print(status.type)
	attack.weapon_resource = weapon_resource.duplicate(true)
	if (CHARACTER is Player):
		attack.weapon_resource.statuses.append_array(CHARACTER.status_weapon_modifiers)
	hitbox.damage(attack)
