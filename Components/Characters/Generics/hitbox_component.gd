class_name HitboxComponent
extends Node3D

signal hit_taken(attack:Attack)

func damage(attack: Attack):
	hit_taken.emit(attack)
