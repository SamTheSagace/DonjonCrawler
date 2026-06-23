extends RefCounted
class_name AttackHitboxContext

var handler: Character
var transform: Node3D
var scene: PackedScene

func _init(h: Character, t: Node3D, s: PackedScene) -> void:
	handler = h
	transform = t
	scene = s
