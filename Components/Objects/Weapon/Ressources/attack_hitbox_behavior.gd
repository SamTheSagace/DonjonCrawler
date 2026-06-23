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

func on_create(context: AttackHitboxContext) -> void:
	_add_to_tree(context)
	_handler = context.handler
	hurtbox = get_node("%WeaponHurtbox")
	hurtbox.hit_Hitbox.connect(_on_hit_Hitbox)
	global_transform = context.transform.global_transform
	print("created attack: ", self, " parent: ", get_parent())
	state = State.ACTIVE


func _add_to_tree(context: AttackHitboxContext) -> void:
	context.transform.add_child(self)

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
