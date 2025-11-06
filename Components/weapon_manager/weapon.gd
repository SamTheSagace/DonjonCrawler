class_name Weapon
extends Node

var weapon_data : WeaponResource

@onready var hitbox : Weapon_Hitbox = $WeaponHitbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.hit_Hitbox.connect(_on_hit_Hitbox)
	pass # Replace with function body.

func _on_hit_Hitbox(hitbox):
		if weapon_data:
			var attack = Attack.new()
			attack.attack_Damage = weapon_data.damage
			hitbox.damage(attack)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
