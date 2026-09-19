extends Character
class_name GhostArm

var time_in_seconds = .1
@export var weapon_manager: WeaponManager
@export var weapon_action: WeaponAction

func _ready():
	assert(weapon_manager != null && weapon_action != null)
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
	weapon_action.start_charge()

func _start_attack():
	weapon_action.start_attack()
