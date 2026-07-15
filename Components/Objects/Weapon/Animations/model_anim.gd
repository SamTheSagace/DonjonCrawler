extends AnimationPlayer
class_name WorldHandAnimation

func _on_chargeInput(weapon_resource: WeaponResource):
	var type := weapon_resource.weapon_superType
	var expectType := WeaponParam.SuperType
	match type:
		expectType.MELEE:
			play("sword_horizontal_charge")
		expectType.RANGED:
			print("ranged")
		_:
			play("sword_charge")

func _on_attackInput(weapon_resource: WeaponResource):
	var type := weapon_resource.weapon_superType
	var expectType := WeaponParam.SuperType
	match type:
		expectType.MELEE:
			play("sword_horizontal_slash")
		expectType.RANGED:
			print("ranged")
		_:
			play("sword_slash")

func _on_parryInput(weapon_resource: WeaponResource):
	var type := weapon_resource.weapon_superType
	var expectType := WeaponParam.SuperType
	match type:
		expectType.MELEE:
			play("sword_parry")
		expectType.RANGED:
			print("ranged")
		_:
			play("sword_parry")

func _on_idleInput():
	play("RESET")


func _on_animation_finished(_anim_name: StringName) -> void:
	if(_anim_name.contains("reset")):
		return
	play("sword_horizontal_reset")
