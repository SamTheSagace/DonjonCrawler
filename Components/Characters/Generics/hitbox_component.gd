class_name HitboxComponent
extends Node3D

signal damage_taken(attack:Attack)

func damage(attack: Attack):
	emit_signal("damage_taken", attack)
