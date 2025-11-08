extends AnimationPlayer

@export var player : CharacterBody3D
@export var weaponManager : WeaponManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weaponManager.attack_Animation.connect(_on_attackInput)
	pass

func _on_attackInput(weapon_resource: WeaponResource):
		if(weapon_resource.weapon_type == WeaponType.Type.MELEE):
			play("sword_slash")
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
