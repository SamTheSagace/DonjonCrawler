extends AnimationPlayer

@export var health_component : HealthComponent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(health_component):
		health_component.damageTaken.connect(_on_damage_taken)
	pass

func _on_damage_taken(_dmg):
	play('damageTaken')
