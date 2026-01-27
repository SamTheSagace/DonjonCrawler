extends AnimationPlayer
class_name WorldHandAnimation

@export var weaponManager : WeaponManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weaponManager.attack_Animation.connect(_on_attackInput)
	pass

func _on_attackInput(weapon_resource: WeaponResource):
		var type := weapon_resource.weapon_type
		var expectType := WeaponType.Type
		if( type == expectType.MELEE):
			play("sword_slash")
		if( type == expectType.RANGED):
			print("ranged")
		else:
			play("sword_slash")

func _on_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass
