class_name Player
extends CharacterBody3D

@export var sensitivity : float = 5
@export var SENSITIVITY := sensitivity *0.001

@export var auto_bhop = true #allow keeping jump button pressed to keep jumping once on the ground
@export var sneak_SPEED := 2.5
@export var walk_SPEED := 5
@export var sprint_SPEED := 8
@export var JUMP_VELOCITY := 7

const HEADBOB_MOVE_AMOUNT = 0.06
const HEADBOB_FRENQUENCY = 2.4
var headbob_time := 0.0

@export var air_cap := 1
@export var air_accel := 800
@export var air_move_speed := 500



var wish_dir := Vector3.ZERO

const MAX_STEP_HEIGHT = 0.5
var _snapped_to_stairs_last_frame := false
var _last_frame_was_on_floor = -INF


@export var view_model_anim : AnimationPlayer
@export var world_model_anim : AnimationPlayer


@onready var head = $Head
@onready var spring_arm = $Head/SpringArm3D
@onready var camera = %Camera3D

signal attackInput()
var upgrades : Array[BasePlayerUpgrade] = []

const SPRING_LENGTH_1 = 0
const SPRING_LENGTH_2 = 5
var _saved_camera_global_pos = null

func get_move_speed() -> float:
	if Input.is_action_pressed("sprint"):
		return sprint_SPEED
	elif Input.is_action_pressed("sneak"):
		return sneak_SPEED 
	else: return walk_SPEED


func _ready():
	spring_arm.spring_length = SPRING_LENGTH_1
	setLayers()


func setLayers():
	if spring_arm.spring_length == SPRING_LENGTH_1:
		for child in %WorldModel.find_children("*", "VisualInstance3D", true, false):
			child.set_layer_mask_value(1, false)
			child.set_layer_mask_value(2, true)
		for child in %ViewModel.find_children("*", "VisualInstance3D", true, false):
			child.set_layer_mask_value(1, true)
			child.set_layer_mask_value(2, false)
	

func _save_camera_pos_for_smoothing():
	if _saved_camera_global_pos == null:
		_saved_camera_global_pos = %CameraSmooth.global_position
		
func _slide_camera_smooth_back_to_origin(delta):
	if _saved_camera_global_pos == null: return
	%CameraSmooth.global_position.y = _saved_camera_global_pos.y
	%CameraSmooth.position.y = clampf(%CameraSmooth.position.y, -0.7, 0.7)
	var move_amount = max(self.velocity.length() * delta, walk_SPEED/2 * delta)
	%CameraSmooth.position.y = move_toward(%CameraSmooth.position.y, 0.0, move_amount)
	_saved_camera_global_pos = %CameraSmooth.global_position
	if %CameraSmooth.position.y == 0:
		_saved_camera_global_pos = null 

func camera_change():
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

func _unhandled_input(event):
	#allow mouse to move around when in the ui vs in game
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#move camera when not in ui
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * SENSITIVITY) 
			head.rotate_x(-event.relative.y * SENSITIVITY)
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	#change between FPS and TPS
	if Input.is_action_just_pressed("camera"):
			camera_change()		
	#check if the springArm TPS is too close to the body, if so hide visual feature so you can still see
	if spring_arm.get_hit_length() <= 1 and spring_arm.spring_length == SPRING_LENGTH_2:
		for child in $WorldModel.find_children("*", "VisualInstance3D"):
				child.set_layer_mask_value(1, false)				
	elif spring_arm.get_hit_length() >= 1 and spring_arm.spring_length == SPRING_LENGTH_2:
		for child in $WorldModel.find_children("*", "VisualInstance3D"):
				child.set_layer_mask_value(1, true)
	#handle actions
	if event.is_action_pressed("left_click"):
		emit_signal("attackInput")


# function to check the angle of surface, return true if steeper than 45
func is_surface_too_steep(normal : Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle

#send a "clone" to raycast potential fall and collision
func _run_body_test_motion(from : Transform3D, motion : Vector3, result = null) -> bool:
	if not result: result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)

func _process(delta):
	pass
	
func _snap_down_to_stairs_check() -> void:
	var did_snap := false
	%StairsBelowRayCast3D.force_raycast_update()
	var floor_below : bool = %StairsBelowRayCast3D.is_colliding() and not is_surface_too_steep(%StairsBelowRayCast3D.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames()  == _last_frame_was_on_floor
	if not is_on_floor() and velocity.y <=0 and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result = PhysicsTestMotionResult3D.new()
		if _run_body_test_motion(self.global_transform, Vector3(0 , -MAX_STEP_HEIGHT, 0), body_test_result):
			#_save_camera_pos_for_smoothing()
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
	_snapped_to_stairs_last_frame = did_snap

func _snap_up_stairs_check(delta) -> bool:
	if not is_on_floor() and not _snapped_to_stairs_last_frame: return false
	# Don't snap stairs if trying to jump, also no need to check for stairs ahead if not moving
	if self.velocity.y > 0 or (self.velocity * Vector3(1,0,1)).length() == 0: return false
	var expected_move_motion = self.velocity * Vector3(1,0,1) * delta
	var step_pos_with_clearance = self.global_transform.translated(expected_move_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))
	# Run a body_test_motion slightly above the pos we expect to move to, towards the floor.
	#  We give some clearance above to ensure there's ample room for the player.
	#  If it hits a step <= MAX_STEP_HEIGHT, we can teleport the player on top of the step
	#  along with their intended motion forward.
	var down_check_result = KinematicCollision3D.new()
	if (self.test_move(step_pos_with_clearance, Vector3(0,-MAX_STEP_HEIGHT*2,0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CSGShape3D"))):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y
		# Note I put the step_height <= 0.01 in just because I noticed it prevented some physics glitchiness
		# 0.02 was found with trial and error. Too much and sometimes get stuck on a stair. Too little and can jitter if running into a ceiling.
		# The normal character controller (both jolt & default) seems to be able to handled steps up of 0.1 anyway
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01 or (down_check_result.get_position() - self.global_position).y > MAX_STEP_HEIGHT: return false
		%StairsAheadRayCast3D.global_position = down_check_result.get_position() + Vector3(0,MAX_STEP_HEIGHT,0) + expected_move_motion.normalized() * 0.1
		%StairsAheadRayCast3D.force_raycast_update()
		if %StairsAheadRayCast3D.is_colliding() and not is_surface_too_steep(%StairsAheadRayCast3D.get_collision_normal()):
			#_save_camera_pos_for_smoothing()
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false

func _handle_air_physics(delta) -> void:
	self.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	#var direction_difference = velocity.normalized().angle_to(wish_dir.normalized())
	#print(direction_difference)
	var curs_speed_in_wish_dir = self.velocity.dot(wish_dir)
	var capped_speed = min((air_move_speed * wish_dir).length(), air_cap)
	var add_speed_till_cap = capped_speed - curs_speed_in_wish_dir
	if add_speed_till_cap > 0:
		var accel_speed = air_accel * air_move_speed * delta
		accel_speed = min(accel_speed, add_speed_till_cap)
		self.velocity += accel_speed * wish_dir

func _handle_ground_physics(delta) -> void:
	self.velocity.x = wish_dir.x * get_move_speed()
	self.velocity.z = wish_dir.z * get_move_speed()
	_headbob_effect(delta)

func _physics_process(delta):
	if is_on_floor(): 
		_last_frame_was_on_floor = Engine.get_physics_frames()
	var input_dir = Input.get_vector("left","right","forward","backward").normalized()
	wish_dir = self.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)
	if is_on_floor() or _snapped_to_stairs_last_frame:
		if Input.is_action_pressed("jump") or (auto_bhop and Input.is_action_pressed("jump")):
			self.velocity.y = JUMP_VELOCITY
		_handle_ground_physics(delta)
	else :
		_handle_air_physics(delta)
	if not _snap_up_stairs_check(delta):
		move_and_slide()
		_snap_down_to_stairs_check()
	
	_slide_camera_smooth_back_to_origin(delta)
		

func _headbob_effect(delta):
	headbob_time += delta * self.velocity.length()
	spring_arm.transform.origin = Vector3(
		cos(headbob_time * HEADBOB_FRENQUENCY * 0.5) * HEADBOB_MOVE_AMOUNT,
		cos(headbob_time * HEADBOB_FRENQUENCY)  * HEADBOB_MOVE_AMOUNT,
		0,
	)

func add_upgrade(upgrade: BasePlayerUpgrade):
	upgrades.append(upgrade)
	upgrade.apply_upgrade(self)

func _input(event):
	pass
