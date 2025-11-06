extends AnimationPlayer

@export var player : CharacterBody3D
@export var weaponManager : Weapon_Manager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weaponManager.attack_Animation.connect(_on_attackInput)
	pass

func _on_attackInput(weaponType):
		if(weaponType == WeaponType.Type.MELEE):
			play("sword_slash")
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
