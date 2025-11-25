extends Character

var time_in_seconds = .2

func _on_player_attack():
	await get_tree().create_timer(time_in_seconds).timeout
	emit_signal("attackInput")
