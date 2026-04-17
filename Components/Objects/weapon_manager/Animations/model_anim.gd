extends AnimationPlayer
class_name WorldHandAnimation

# Called when the node enters the scene tree for the first time.

func _on_chargeInput(weapon_resource: WeaponResource):
	var type := weapon_resource.weapon_type
	var expectType := WeaponType.Type
	match type:
		expectType.MELEE:
			play("sword_charge")
		expectType.RANGED:
			print("ranged")
		_:
			play("sword_charge")

func _on_attackInput(weapon_resource: WeaponResource):
	var type := weapon_resource.weapon_type
	var expectType := WeaponType.Type
	match type:
		expectType.MELEE:
			play("sword_slash")
		expectType.RANGED:
			print("ranged")
		_:
			play("sword_slash")

func _on_parryInput(weapon_resource: WeaponResource):
	var type := weapon_resource.weapon_type
	var expectType := WeaponType.Type
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
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass
