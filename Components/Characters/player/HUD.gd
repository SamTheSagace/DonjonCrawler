extends CanvasLayer

@export var health: HealthComponent
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health :
		var maxHealth = health.Max_health
		var currrentHealth = health.health
		var percentHealth = ((currrentHealth*100) / maxHealth)
		if percentHealth > 0:
			print(percentHealth)
		%HealthBar.value = percentHealth
	pass
