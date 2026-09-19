extends CanvasLayer

@export var player: Player

func _ready() -> void:
	assert(player != null)

func _process(_delta: float) -> void:
	var max_health = player.health_component.Max_health
	var current_health = player.health_component.health
	var percent_health = ((current_health*100) / max_health)
	%HealthBar.value = percent_health
	%health_text.text = str(player.health_component.health)
	var statuses = player.stateMachine.weapon_manager.weapon_resource.statuses
	%status_onweapon.text = StatusType.get_statuses_string(statuses)
