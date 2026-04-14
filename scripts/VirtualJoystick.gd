extends Control
## Virtual joystick for touch input.
## Add a ColorRect or TextureRect child named "Base" and another named "Knob".

@export var joystick_radius: float = 80.0

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


## Returns a normalized Vector2 in range [-1, 1] on each axis.
func get_output() -> Vector2:
	return _output


## True when the joystick is actively being held.
func is_active() -> bool:
	return _touch_index != -1
