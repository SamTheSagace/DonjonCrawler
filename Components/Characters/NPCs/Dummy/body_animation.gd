extends AnimationPlayer

@export var health : HealthComponent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.damageTaken.connect(_on_damage_taken)
	pass

func _on_damage_taken(dmg):
	play('damageTaken')
