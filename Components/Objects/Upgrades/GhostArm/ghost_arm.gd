extends Character
class_name GhostArm

var time_in_seconds = .1
var ghostWeaponManager : WeaponManager

func _ready():
	assert(ghostWeaponManager != null)
	pass

var queue: Array = []
var processing := false

func _on_signal_attack(isAttack: bool):
	queue.push_back(isAttack)
	if not processing:
		process_queue()

func process_queue():
	processing = true
	while queue.size() > 0:
		var isAttack = queue.pop_front()
		await get_tree().create_timer(time_in_seconds).timeout
		if isAttack:
			_start_attack()
		else:
			_start_charge()
	processing = false

func _start_charge():
	ghostWeaponManager.start_charge()

func _start_attack():
	ghostWeaponManager.start_attack()
