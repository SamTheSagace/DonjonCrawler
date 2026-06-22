extends Node3D
class_name AttackHitboxBehavior

signal hit_Hitbox(target)
signal attack_ended

enum State {INACTIVE, ACTIVE, EXPIRING}
var state := State.INACTIVE

var _handler: Character
var hurtbox: WeaponHurtbox


static func create(context: AttackHitboxContext) -> AttackHitboxBehavior:
	var attack = context.scene.instantiate() as AttackHitboxBehavior
	attack.on_create(context)
	attack.state = State.ACTIVE
	return attack

func on_create(context: AttackHitboxContext, ) -> void:
	var attack = self as AttackHitboxBehavior
	_add_to_tree(context)
	attack._handler = context.handler
	attack.global_transform = context.transform.global_transform 
	attack.hurtbox = attack.get_node("%WeaponHurtbox")
	attack.hurtbox.hit_Hitbox.connect(attack._on_hit_Hitbox)


func _add_to_tree(context: AttackHitboxContext) -> void:
	context.parent.add_child(self)

func expire() -> void:
	if state != State.ACTIVE:
		return
	state = State.EXPIRING
	on_expire()


func on_expire() -> void:
	_finish() # default: instant

func _finish() -> void:
	attack_ended.emit()
	queue_free()

func _on_hit_Hitbox(hitbox) -> void:
	if state == State.ACTIVE and hitbox != _handler.HITBOX:
		hit_Hitbox.emit(hitbox)
