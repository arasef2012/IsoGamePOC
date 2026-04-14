extends CharacterBody2D

const SPEED: float = 200.0

## Assigned by Main scene after HUD is ready.
var move_joystick: Control = null
var shoot_joystick: Control = null

# Isometric projection factor — squishes vertical movement so it reads as depth.
const ISO_Y_SCALE: float = 0.5

var _facing_right: bool = true


func _draw() -> void:
	# Placeholder isometric character — replace with Sprite2D + atlas later.
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
	# Direction dot so facing is obvious
	var dot_x := 10.0 if _facing_right else -10.0
	draw_circle(Vector2(dot_x, -8), 4.0, Color.WHITE)


func _physics_process(_delta: float) -> void:
	_handle_movement()
	_handle_shooting()


func _handle_movement() -> void:
	var dir := Vector2.ZERO

	if move_joystick and move_joystick.is_active():
		dir = move_joystick.get_output()
	else:
		# Keyboard fallback (desktop / testing)
		dir.x = Input.get_axis("move_left", "move_right")
		dir.y = Input.get_axis("move_up", "move_down")

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
	if shoot_joystick and shoot_joystick.is_active():
		var shoot_dir: Vector2 = shoot_joystick.get_output()
		if shoot_dir.length() > 0.3:
			_fire(shoot_dir)


func _fire(direction: Vector2) -> void:
	# TODO: instance a Bullet scene, set its velocity, add to world.
	pass
