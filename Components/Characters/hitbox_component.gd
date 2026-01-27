class_name HitboxComponent
extends Node3D

@export var health_component : HealthComponent

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
