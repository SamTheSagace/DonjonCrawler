extends Node3D
class_name HandAnimation


signal animation_finished
@export var animation : WorldHandAnimation

func _ready():
	animation.animation_finished.connect(_finish_animation)

func _finish_animation():
	emit_signal("animation_finished")
