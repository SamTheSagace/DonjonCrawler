extends AnimationPlayer
class_name WorldHandAnimation

@export var weaponManager : WeaponManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weaponManager.attack_animation.connect(_on_attackInput)
	weaponManager.parry_animation.connect(_on_parryInput)
	weaponManager.reset_animation.connect(_on_idleInput)
	pass

func _on_attackInput(weapon_resource: WeaponResource):
	print(weapon_resource)
	var type := weapon_resource.weapon_type
	var expectType := WeaponType.Type
	if( type == expectType.MELEE):
		play("sword_slash")
	if( type == expectType.RANGED):
		print("ranged")
	else:
		play("sword_slash")

func _on_parryInput(weapon_resource: WeaponResource):
	var type := weapon_resource.weapon_type
	var expectType := WeaponType.Type
	if( type == expectType.MELEE):
		play("sword_parry")
	if( type == expectType.RANGED):
		print("ranged")
	else:
		play("sword_parry")

func _on_idleInput():
	play("RESET")


func _on_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass
