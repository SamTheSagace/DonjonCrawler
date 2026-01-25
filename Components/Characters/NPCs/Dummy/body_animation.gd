extends AnimationPlayer

@export var HEALTH_COMPONENT : HealthComponent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(HEALTH_COMPONENT):
		HEALTH_COMPONENT.damageTaken.connect(_on_damage_taken)
	pass

func _on_damage_taken(dmg):
	play('damageTaken')
