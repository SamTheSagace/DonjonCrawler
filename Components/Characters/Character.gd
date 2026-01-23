class_name Character
extends CharacterBody3D


@export var SPEED := 5.0
@export var JUMP_VELOCITY := 4.5
@export var SNEAK_SPEED := 0.5
@export var SPRINT_SPEED := 1.5
@export var MAX_HEALTH := 60
@export var HEALTH_COMPONENT : HealthComponent
@export var MOVEMENT_COMPONENT : MovementComponent
@export var SMC: StateMachineCombat

signal attackInput()

func _ready():
	if HEALTH_COMPONENT != null:
		HEALTH_COMPONENT.set_max_health(MAX_HEALTH)
	if MOVEMENT_COMPONENT != null:
		MOVEMENT_COMPONENT.set_stats(SPEED, JUMP_VELOCITY, SNEAK_SPEED, SPRINT_SPEED)
