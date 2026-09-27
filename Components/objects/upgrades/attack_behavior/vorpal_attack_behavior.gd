extends AttackBehavior
class_name AttackBehaviorVorpal


func _on_start(_hitbox: WeaponHurtboxAttack, _weapon: BaseWeapon, _controller: AttackController):
	_weapon.get_tree().current_scene.add_child(_hitbox)
	_hitbox.global_transform = _weapon.global_transform

func tick(_hitbox: WeaponHurtboxAttack, _weapon: BaseWeapon,_delta:float):
	_hitbox.global_transform = _weapon.global_transform

func _on_finish(hitbox: WeaponHurtboxAttack):
	hitbox.decay_timer = 10
	hitbox.start_decay_timer()
