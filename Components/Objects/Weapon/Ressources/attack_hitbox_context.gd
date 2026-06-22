extends RefCounted
class_name AttackHitboxContext

var handler: Character
var parent: Node
var transform: Node3D
var scene: PackedScene

func _init(h: Character, p: Node, t: Node3D, s: PackedScene) -> void:
	handler = h
	parent = p
	transform = t
	scene = s
