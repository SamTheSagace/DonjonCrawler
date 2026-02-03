extends Character
class_name GhostArm

var time_in_seconds = .2
signal ghostAttackInput
func _ready():
	pass
func _on_player_attack():
	await get_tree().create_timer(time_in_seconds).timeout
	attack()

func attack():
	emit_signal("ghostAttackInput")
