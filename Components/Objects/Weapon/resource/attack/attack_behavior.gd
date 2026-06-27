extends Resource
class_name AttackBehavior

func _on_start(_hitbox: WeaponHurtboxAttack, _weapon: BaseWeapon, _controller: AttackController): pass

func _on_finish(_hitbox: WeaponHurtboxAttack): pass

func on_hit(_hitbox: WeaponHurtboxAttack, _target: Character): pass

func tick(_delta): pass
