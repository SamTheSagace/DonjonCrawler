class_name MovementController
extends Node

# --- Player reference ---
var player: CharacterBody3D

# --- Movement tuning ---
@export var auto_bhop := true
@export var sneak_SPEED := 2.5
@export var walk_SPEED := 5.0
@export var sprint_SPEED := 8.0
@export var JUMP_VELOCITY := 7.0

@export var air_cap := 1.0
@export var air_accel := 800.0
@export var air_move_speed := 500.0
@export var max_step_height := 0.5

# --- Headbob settings ---
const HEADBOB_MOVE_AMOUNT := 0.06
const HEADBOB_FREQUENCY := 2.4
var headbob_time := 0.0

# --- State ---
var wish_dir := Vector3.ZERO
var snapped_to_stairs_last_frame := false
var last_frame_was_on_floor := -INF

func setup(body: CharacterBody3D):
	player = body

# -----------------------------
# PHYSICS HANDLER
# -----------------------------
func handle_physics(delta: float):
	if player.is_on_floor():
		last_frame_was_on_floor = Engine.get_physics_frames()

	var input_dir = Input.get_vector("left", "right", "forward", "backward").normalized()
	wish_dir = player.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)

	if player.is_on_floor() or snapped_to_stairs_last_frame:
		if Input.is_action_pressed("jump") or (auto_bhop and Input.is_action_pressed("jump")):
			player.velocity.y = JUMP_VELOCITY
		_handle_ground_physics(delta)
	else:
		_handle_air_physics(delta)

	if not _snap_up_stairs_check(delta):
		player.move_and_slide()
		_snap_down_to_stairs_check()

	_headbob_effect(delta)

# -----------------------------
# MOVEMENT PHYSICS
# -----------------------------
func _handle_ground_physics(delta: float):
	player.velocity.x = wish_dir.x * _get_move_speed()
	player.velocity.z = wish_dir.z * _get_move_speed()

func _handle_air_physics(delta: float):
	player.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	var curs_speed_in_wish_dir = player.velocity.dot(wish_dir)
	var capped_speed = min((air_move_speed * wish_dir).length(), air_cap)
	var add_speed_till_cap = capped_speed - curs_speed_in_wish_dir
	if add_speed_till_cap > 0:
		var accel_speed = air_accel * air_move_speed * delta
		accel_speed = min(accel_speed, add_speed_till_cap)
		player.velocity += accel_speed * wish_dir

func _get_move_speed() -> float:
	if Input.is_action_pressed("sprint"):
		return sprint_SPEED
	elif Input.is_action_pressed("sneak"):
		return sneak_SPEED
	else:
		return walk_SPEED

# -----------------------------
# STAIRS / STEP HANDLING
# -----------------------------
func is_surface_too_steep(normal: Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > player.floor_max_angle

func _run_body_test_motion(from: Transform3D, motion: Vector3, result = null) -> bool:
	if not result:
		result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(player.get_rid(), params, result)

func _snap_down_to_stairs_check() -> void:
	var did_snap := false
	%StairsBelowRayCast3D.force_raycast_update()
	var floor_below := %StairsBelowRayCast3D.is_colliding() 
		and not is_surface_too_steep(%StairsBelowRayCast3D.get_collision_normal())
	var was_on_floor_last_frame := Engine.get_physics_frames() == last_frame_was_on_floor

	if not player.is_on_floor() and player.velocity.y <= 0 and (was_on_floor_last_frame or snapped_to_stairs_last_frame) and floor_below:
		var body_test_result = PhysicsTestMotionResult3D.new()
		if _run_body_test_motion(player.global_transform, Vector3(0, -max_step_height, 0), body_test_result):
			player.position.y += body_test_result.get_travel().y
			player.apply_floor_snap()
			did_snap = true

	snapped_to_stairs_last_frame = did_snap

func _snap_up_stairs_check(delta) -> bool:
	if not player.is_on_floor() and not snapped_to_stairs_last_frame:
		return false
	if player.velocity.y > 0 or (player.velocity * Vector3(1, 0, 1)).length() == 0:
		return false

	var expected_move_motion = player.velocity * Vector3(1, 0, 1) * delta
	var step_pos_with_clearance = player.global_transform.translated(expected_move_motion + Vector3(0, max_step_height * 2, 0))
	var down_check_result = KinematicCollision3D.new()

	if player.test_move(step_pos_with_clearance, Vector3(0, -max_step_height * 2, 0), down_check_result) \
	and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CSGShape3D")):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - player.global_position).y
		if step_height > max_step_height or step_height <= 0.01 or (down_check_result.get_position() - player.global_position).y > max_step_height:
			return false

		%StairsAheadRayCast3D.global_position = down_check_result.get_position() + Vector3(0, max_step_height, 0) + expected_move_motion.normalized() * 0.1
		%StairsAheadRayCast3D.force_raycast_update()
		if %StairsAheadRayCast3D.is_colliding() and not is_surface_too_steep(%StairsAheadRayCast3D.get_collision_normal()):
			player.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			player.apply_floor_snap()
			snapped_to_stairs_last_frame = true
			return true
	return false

# -----------------------------
# HEADBOB
# -----------------------------
func _headbob_effect(delta):
	headbob_time += delta * player.velocity.length()
	player.spring_arm.transform.origin = Vector3(
		cos(headbob_time * HEADBOB_FREQUENCY * 0.5) * HEADBOB_MOVE_AMOUNT,
		cos(headbob_time * HEADBOB_FREQUENCY) * HEADBOB_MOVE_AMOUNT,
		0,
	)
