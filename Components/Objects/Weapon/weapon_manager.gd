extends Node3D
class_name WeaponManager

@export var weapon_resource: WeaponResource
@export var hand_anim: HandAnimation
@export var CHARACTER: Character

signal weapon_equipped(weapon: BaseWeapon)

var weapon: BaseWeapon
var hand: Node3D

func _ready() -> void:
	assert(weapon_resource != null)
	assert(hand_anim != null)
	await hand_anim.ready
	hand = hand_anim.hand
	weapon_resource = weapon_resource.duplicate(true)
	weapon_match()

func weapon_match():
	assert(weapon_resource.weapon_superType != null)
	match (weapon_resource.weapon_superType):
		WeaponParam.SuperType.MELEE:
			update_weapon()
		_:
			print("unknown type")

func update_weapon():
	clean_up_weapon()
	weapon = weapon_resource.instantiate_weapon(CHARACTER)
	hand.add_child(weapon)
	weapon_equipped.emit(weapon)

func clean_up_weapon():
	if hand.has_node("Weapon"):
		hand.get_node("Weapon").queue_free()
