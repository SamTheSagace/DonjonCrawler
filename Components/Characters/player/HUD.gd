extends CanvasLayer

@export var HEALTH_COMPONENT: HealthComponent
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if HEALTH_COMPONENT:
		var maxHealth = HEALTH_COMPONENT.Max_health
		var currrentHealth = HEALTH_COMPONENT.health
		var percentHealth = ((currrentHealth*100) / maxHealth)
		%HealthBar.value = percentHealth
		%health_text.text = str(HEALTH_COMPONENT.health)
	pass
