extends CharacterBody2D

const SPEED: float = 200.0

## Assigned by Main scene after HUD is ready.
var move_joystick: Control = null
var shoot_joystick: Control = null

const ISO_Y_SCALE: float = 0.5
const BARREL_LENGTH: float = 32.0
const BARREL_WIDTH: float = 5.0

var _facing_right: bool = true
var _gun_dir: Vector2 = Vector2.RIGHT  # persists last aimed direction


func _draw() -> void:
	_draw_body()
	_draw_gun()


func _draw_body() -> void:
	var body := PackedVector2Array([
		Vector2(0,   -24),
		Vector2(16,  -12),
		Vector2(16,    8),
		Vector2(0,    20),
		Vector2(-16,   8),
		Vector2(-16, -12),
	])
	var fill := Color(0.2, 0.6, 1.0) if _facing_right else Color(0.2, 0.4, 0.9)
	draw_colored_polygon(body, fill)
	draw_polyline(
		PackedVector2Array([body[0], body[1], body[2], body[3], body[4], body[5], body[0]]),
		Color.WHITE, 1.5
	)


func _draw_gun() -> void:
	var dir := _gun_dir.normalized()
	# Pivot the gun from the character's shoulder area
	var pivot := Vector2(0, -10)
	var tip := pivot + dir * BARREL_LENGTH

	# Barrel — perpendicular offset gives it width
	var perp := Vector2(-dir.y, dir.x) * (BARREL_WIDTH * 0.5)
	var barrel := PackedVector2Array([
		pivot + perp,
		tip   + perp,
		tip   - perp,
		pivot - perp,
	])
	draw_colored_polygon(barrel, Color(0.6, 0.6, 0.6))
	draw_polyline(
		PackedVector2Array([barrel[0], barrel[1], barrel[2], barrel[3], barrel[0]]),
		Color(0.3, 0.3, 0.3), 1.0
	)
	# Muzzle dot
	draw_circle(tip, 4.0, Color(0.9, 0.8, 0.2))


func _physics_process(_delta: float) -> void:
	_handle_movement()
	_handle_shooting()


func _handle_movement() -> void:
	var dir := Vector2.ZERO

	if move_joystick and move_joystick.is_active():
		dir = move_joystick.get_output()

	if dir != Vector2.ZERO:
		dir = dir.normalized()

	velocity = Vector2(dir.x * SPEED, dir.y * SPEED * ISO_Y_SCALE)
	move_and_slide()

	if dir.x != 0:
		var was_right := _facing_right
		_facing_right = dir.x > 0
		if _facing_right != was_right:
			queue_redraw()


func _handle_shooting() -> void:
	var shoot_dir := Vector2.ZERO
	if shoot_joystick and shoot_joystick.is_active():
		shoot_dir = shoot_joystick.get_output()

	if shoot_dir.length() > 0.1:
		# Update gun direction and redraw whenever aim changes meaningfully
		if shoot_dir.normalized().distance_to(_gun_dir.normalized()) > 0.01:
			_gun_dir = shoot_dir
			queue_redraw()

		if shoot_dir.length() > 0.3:
			_fire(_gun_dir.normalized())


func _fire(direction: Vector2) -> void:
	# TODO: instance a Bullet scene, set its velocity, add to world.
	pass
