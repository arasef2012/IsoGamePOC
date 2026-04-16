extends Control
## Virtual joystick for touch input with keyboard fallback for PC testing.
## Set the four action_* exports to route keyboard input through this joystick.

@export var joystick_radius: float = 80.0

## Input action names for keyboard fallback (leave empty to disable).
@export var action_left: String = ""
@export var action_right: String = ""
@export var action_up: String = ""
@export var action_down: String = ""

var _touch_index: int = -1
var _center: Vector2
var _output: Vector2 = Vector2.ZERO

@onready var _knob: Control = $Knob


func _ready() -> void:
	_center = size / 2.0


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and _touch_index == -1:
			if _is_inside(event.position):
				_touch_index = event.index
				_update_knob(event.position)
		elif not event.pressed and event.index == _touch_index:
			_release()

	elif event is InputEventScreenDrag:
		if event.index == _touch_index:
			_update_knob(event.position)


func _is_inside(screen_pos: Vector2) -> bool:
	var local_pos := screen_pos - global_position
	return local_pos.distance_to(_center) <= joystick_radius


func _update_knob(screen_pos: Vector2) -> void:
	var local_pos := screen_pos - global_position
	var delta := local_pos - _center
	if delta.length() > joystick_radius:
		delta = delta.normalized() * joystick_radius
	_output = delta / joystick_radius
	_knob.position = _center - _knob.size / 2.0 + delta


func _release() -> void:
	_touch_index = -1
	_output = Vector2.ZERO
	_knob.position = _center - _knob.size / 2.0


func _keyboard_output() -> Vector2:
	if action_left == "" and action_right == "" and action_up == "" and action_down == "":
		return Vector2.ZERO
	return Vector2(
		Input.get_axis(action_left, action_right),
		Input.get_axis(action_up, action_down)
	)


## Returns a Vector2 in range [-1, 1] per axis.
## Touch input takes priority; falls back to keyboard when no finger is active.
func get_output() -> Vector2:
	if _touch_index != -1:
		return _output
	return _keyboard_output()


## True when the joystick has active input from touch or keyboard.
func is_active() -> bool:
	if _touch_index != -1:
		return true
	return _keyboard_output().length() > 0.0
