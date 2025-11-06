class_name Weapon_Hitbox
extends Node3D

signal hit_Hitbox(new_value)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_collision_area_entered(area):
	if area is HitboxComponent:
		var hitbox: HitboxComponent = area
		emit_signal("hit_Hitbox", hitbox)
	 # Replace with function body.
