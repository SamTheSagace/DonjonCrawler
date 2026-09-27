extends Node3D
class_name BaseWeapon

signal hit_Hitbox(target: HitboxComponent)

@export var attack_definition: AttackDefinition

var controller := AttackController.new()


func _ready():
	assert(attack_definition != null)
	add_child(controller)
	controller.hit_Hitbox.connect(_on_hit_Hitbox)
	pass

func set_attacking():
	controller.start_attack(attack_definition, self)

func stop_attacking():
	controller.finish_attack()

func _on_hit_Hitbox(hitbox):
	hit_Hitbox.emit(hitbox)

func _process(delta: float) -> void:
	controller.tick(delta, self)
