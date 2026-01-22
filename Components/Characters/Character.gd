class_name Character
extends CharacterBody3D


@export var SPEED := 5.0
@export var JUMP_VELOCITY := 4.5
@export var MAX_HEALTH := 60
@export var HEALTH_COMPONENT : HealthComponent


signal attackInput()

func _ready():
	HEALTH_COMPONENT.set_max_health(MAX_HEALTH)
