extends CanvasLayer

@export var player: Player
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	assert(player != null)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var maxHealth = player.HEALTH_COMPONENT.Max_health
	var currrentHealth = player.HEALTH_COMPONENT.health
	var percentHealth = ((currrentHealth*100) / maxHealth)
	%HealthBar.value = percentHealth
	%health_text.text = str(player.HEALTH_COMPONENT.health)
	var statuses =player.stateMachine.WEAPON_MANAGER.weapon_resource.statuses
	%status_onweapon.text = StatusType.get_statuses_string(statuses)
	pass
