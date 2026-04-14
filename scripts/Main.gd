extends Node2D


func _ready() -> void:
	var player: CharacterBody2D = $WorldRoot/Player
	var hud: CanvasLayer = $HUD

	# Wire joysticks to player.
	player.move_joystick = hud.get_node("MoveJoystick")
	player.shoot_joystick = hud.get_node("ShootJoystick")
