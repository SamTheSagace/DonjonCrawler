extends AttackHitboxBehavior
class_name VorpalAttack

const LINGER_DURATION := 1.0
var _follow_target: Node3D


func on_create(context: AttackHitboxContext) -> void:
	_follow_target = context.transform
	super.on_create(context)


func _add_to_tree(_context: AttackHitboxContext) -> void:
	get_tree().root.add_child(self)


func _process(_delta: float) -> void:
	if _follow_target and state == State.ACTIVE:
		global_transform = _follow_target.global_transform


func on_expire() -> void:
	_follow_target = null
	await get_tree().create_timer(LINGER_DURATION).timeout
	_finish()
