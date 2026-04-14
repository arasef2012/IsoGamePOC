extends CharacterBody2D

const SPEED: float = 200.0

## Assigned by Main scene after HUD is ready.
var move_joystick: Control = null
var shoot_joystick: Control = null

# Isometric projection factor — squishes vertical movement so it reads as depth.
const ISO_Y_SCALE: float = 0.5


func _physics_process(delta: float) -> void:
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

	# Apply isometric Y scaling so diagonal movement looks correct on an iso grid.
	velocity = Vector2(dir.x * SPEED, dir.y * SPEED * ISO_Y_SCALE)
	move_and_slide()

	# Flip sprite to face movement direction.
	if dir.x != 0:
		$Sprite2D.flip_h = dir.x < 0


func _handle_shooting() -> void:
	if shoot_joystick and shoot_joystick.is_active():
		var shoot_dir: Vector2 = shoot_joystick.get_output()
		if shoot_dir.length() > 0.3:
			_fire(shoot_dir)


func _fire(direction: Vector2) -> void:
	# TODO: instance a Bullet scene, set its velocity, add to world.
	pass
