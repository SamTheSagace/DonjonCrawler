extends Node3D
class_name WeaponAction

@export var hand_anim: HandAnimation
@export var weapon_storage: WeaponManager
@onready var CHARACTER = weapon_storage.CHARACTER

signal attack_started(is_attack: bool)

var attack_finished := true
var parry_finished := true

func _ready() -> void:
	assert(hand_anim != null)
	assert(weapon_storage != null)
	hand_anim.animation_finished.connect(finish_animation)
	weapon_storage.weapon_equipped.connect(_on_weapon_equipped)
	if weapon_storage.weapon != null:
		_on_weapon_equipped(weapon_storage.weapon)

func _on_weapon_equipped(weapon: BaseWeapon):
	weapon.hit_Hitbox.connect(attack_Hit)

func go_to_idle():
	hand_anim._on_idleInput()

func start_charge():
	attack_started.emit(false)
	hand_anim._on_chargeInput(weapon_storage.weapon_resource)

func start_attack():
	print(weapon_storage.weapon.attack_definition.behavior.get_script().get_global_name())
	attack_finished = false
	attack_started.emit(true)
	weapon_storage.weapon.set_attacking()
	hand_anim._on_attackInput(weapon_storage.weapon_resource)

func finish_animation(value: String):
	var isAttackAnim = value.contains("slash") || value.contains("thrust")
	if isAttackAnim:
		attack_finished = true
		weapon_storage.weapon.stop_attacking()
	if value == "sword_parry":
		parry_finished = true

func start_parry():
	parry_finished = false
	if (hand_anim.animation.current_animation != "RESET"):
		weapon_storage.weapon.set_attacking()
		hand_anim._on_parryInput(weapon_storage.weapon_resource)
		return
	hand_anim._on_parryInput(weapon_storage.weapon_resource)

func attack_Hit(hitbox: HitboxComponent):
	if (hitbox == CHARACTER.HITBOX):
		return
	var attack = Attack.new()
	attack.attacker = CHARACTER
	var statuses = weapon_storage.weapon_resource.statuses
	if (statuses.size() > 0):
		for status: StatusDefinition in statuses:
			if (status == null):
				statuses.erase(status)
			# else:
			# 	print(status.type)
	attack.weapon_resource = weapon_storage.weapon_resource.duplicate(true)
	if (CHARACTER is Player):
		attack.weapon_resource.statuses.append_array(CHARACTER.status_weapon_modifiers)
	hitbox.damage(attack)
