extends AttackBehavior
class_name AttackBehaviorBase

func _on_start(_hitbox: WeaponHurtboxAttack, _weapon: BaseWeapon, _controller: AttackController):
	_weapon.add_child(_hitbox)

func _on_finish(hitbox: WeaponHurtboxAttack):
	hitbox.queue_free()
