extends Node3D
class_name HandAnimation


signal animation_finished(anim_name: StringName)
@export var animation: WorldHandAnimation
@onready var hand = %Hand

func _ready():
	animation.animation_finished.connect(_finish_animation)

func _finish_animation(anim_name: StringName):
	animation_finished.emit(anim_name)


func _on_chargeInput(weapon_resource: WeaponResource):
	animation._on_chargeInput(weapon_resource)

func _on_attackInput(weapon_resource: WeaponResource):
	animation._on_attackInput(weapon_resource)

func _on_parryInput(weapon_resource: WeaponResource):
	animation._on_parryInput(weapon_resource)

func _on_idleInput():
	animation._on_idleInput()
