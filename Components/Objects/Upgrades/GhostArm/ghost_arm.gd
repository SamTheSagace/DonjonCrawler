extends Character
class_name GhostArm

var time_in_seconds = .1
signal ghostAttackInput
var ghostWeaponManager : WeaponManager

func _ready():
	assert(ghostWeaponManager != null)
	pass

func _on_start_charge():
	await get_tree().create_timer(time_in_seconds).timeout
	ghostWeaponManager.start_charge()

var attack_pending := false

func _on_start_attack():
	print("should attack")
	if attack_pending:
		return
	attack_pending = true
	await get_tree().create_timer(3.0).timeout
	ghostWeaponManager.start_attack()
	attack_pending = false
