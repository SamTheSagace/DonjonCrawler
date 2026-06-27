extends Node3D
class_name AttackHitboxBehavior

signal hit_Hitbox(target: HitboxComponent)
signal attack_ended

enum State {INACTIVE, ACTIVE, EXPIRING}
var state := State.INACTIVE

var _handler: Character
var instantiate_Attack: WeaponHurtboxAttack

func create(context: AttackHitboxContext):
	assert(context.scene != null)
	on_create(context)

func on_create(context: AttackHitboxContext) -> void:
	instantiate_Attack = context.scene.instantiate() as WeaponHurtboxAttack
	_add_to_tree(context)
	_handler = context.handler
	instantiate_Attack.hit_Hitbox.connect(_on_hit_Hitbox)
	instantiate_Attack.global_transform = context.scene.global_transform
	state = State.ACTIVE


func _add_to_tree(context: AttackHitboxContext) -> void:
	context.self.add_child(instantiate_Attack)

func expire() -> void:
	if state != State.ACTIVE:
		return
	state = State.EXPIRING
	on_expire()


func on_expire() -> void:
	attack_ended.emit()
	queue_free()

func _on_hit_Hitbox(hitbox) -> void:
	if state == State.ACTIVE and hitbox != _handler.HITBOX:
		hit_Hitbox.emit(hitbox)
