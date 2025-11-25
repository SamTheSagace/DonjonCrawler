class_name Player
extends Character

@export var sensitivity: float = 5.0
@export var SENSITIVITY := sensitivity * 0.001
@export var movement_controller : MovementController

@onready var head = $Head
@onready var spring_arm = $Head/SpringArm3D
@onready var camera = %Camera3D

const SPRING_LENGTH_1 := 0
const SPRING_LENGTH_2 := 5

var _saved_camera_global_pos = null

var upgrades : Array[BasePlayerUpgrade] = []

func _ready():
	spring_arm.spring_length = SPRING_LENGTH_1
	_set_layers()

func _set_layers():
	if spring_arm.spring_length == SPRING_LENGTH_1:
		for child in %WorldModel.find_children("*", "VisualInstance3D", true, false):
			child.set_layer_mask_value(1, false)
			child.set_layer_mask_value(2, true)
		for child in %ViewModel.find_children("*", "VisualInstance3D", true, false):
			child.set_layer_mask_value(1, true)
			child.set_layer_mask_value(2, false)

func _unhandled_input(event):
	# Mouse capture toggle
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Mouse look
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)
		head.rotate_x(-event.relative.y * SENSITIVITY)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

	# Toggle camera
	if Input.is_action_just_pressed("camera"):
		_camera_change()

	# Handle visibility for TPS camera collision
	if spring_arm.get_hit_length() <= 1 and spring_arm.spring_length == SPRING_LENGTH_2:
		for child in $WorldModel.find_children("*", "VisualInstance3D"):
			child.set_layer_mask_value(1, false)
	elif spring_arm.get_hit_length() >= 1 and spring_arm.spring_length == SPRING_LENGTH_2:
		for child in $WorldModel.find_children("*", "VisualInstance3D"):
			child.set_layer_mask_value(1, true)
			
	if event.is_action_pressed("left_click"):
		emit_signal("attackInput")

func _camera_change():
	if spring_arm.spring_length == SPRING_LENGTH_1:
		spring_arm.spring_length = SPRING_LENGTH_2
		for child in $WorldModel.find_children("*", "VisualInstance3D", true, false):
			child.set_layer_mask_value(1, true)
		for child in %ViewModel.find_children("*", "VisualInstance3D", true, false):
			child.set_layer_mask_value(1, false)
	else:
		spring_arm.spring_length = SPRING_LENGTH_1
		for child in $WorldModel.find_children("*", "VisualInstance3D", true, false):
			child.set_layer_mask_value(1, false)
		for child in %ViewModel.find_children("*", "VisualInstance3D", true, false):
			child.set_layer_mask_value(1, true)

func _physics_process(delta:float):
	movement_controller.handle_physics(delta)

# Optional smooth-camera helper
func _save_camera_pos_for_smoothing():
	if _saved_camera_global_pos == null:
		_saved_camera_global_pos = %CameraSmooth.global_position

func _slide_camera_smooth_back_to_origin(delta):
	if _saved_camera_global_pos == null:
		return
	%CameraSmooth.global_position.y = _saved_camera_global_pos.y
	%CameraSmooth.position.y = clampf(%CameraSmooth.position.y, -0.7, 0.7)
	var move_amount = max(velocity.length() * delta, 2.5 * delta)
	%CameraSmooth.position.y = move_toward(%CameraSmooth.position.y, 0.0, move_amount)
	_saved_camera_global_pos = %CameraSmooth.global_position
	if %CameraSmooth.position.y == 0:
		_saved_camera_global_pos = null


func add_upgrade(upgrade: BasePlayerUpgrade):
	upgrades.append(upgrade)
	upgrade.apply_upgrade(self)
