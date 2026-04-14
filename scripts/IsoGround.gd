extends Node2D
## Draws a procedural isometric tile grid — no art assets needed.
## Position this node so the grid center sits at the screen center.

@export var grid_width: int = 14
@export var grid_height: int = 14
@export var tile_width: int = 128
@export var tile_height: int = 64
@export var tile_color: Color = Color(0.22, 0.42, 0.22)
@export var border_color: Color = Color(0.12, 0.28, 0.12)


func _draw() -> void:
	# Draw back-to-front so overlapping borders look correct.
	for y in range(grid_height):
		for x in range(grid_width):
			_draw_tile(x, y)


func _draw_tile(gx: int, gy: int) -> void:
	var c := _to_screen(gx, gy)
	var hw := tile_width * 0.5
	var hh := tile_height * 0.5
	var pts := PackedVector2Array([
		Vector2(c.x,      c.y - hh),  # top
		Vector2(c.x + hw, c.y),        # right
		Vector2(c.x,      c.y + hh),  # bottom
		Vector2(c.x - hw, c.y),        # left
	])
	draw_colored_polygon(pts, PackedColorArray([tile_color]))
	draw_polyline(
		PackedVector2Array([pts[0], pts[1], pts[2], pts[3], pts[0]]),
		border_color, 1.0
	)


## Converts grid coordinates to local 2D screen coordinates.
func _to_screen(gx: int, gy: int) -> Vector2:
	return Vector2(
		(gx - gy) * (tile_width * 0.5),
		(gx + gy) * (tile_height * 0.5)
	)


## Helper: convert a world position back to the nearest grid cell.
func world_to_grid(world_pos: Vector2) -> Vector2i:
	var local_pos := world_pos - global_position
	var gx := (local_pos.x / (tile_width * 0.5) + local_pos.y / (tile_height * 0.5)) * 0.5
	var gy := (local_pos.y / (tile_height * 0.5) - local_pos.x / (tile_width * 0.5)) * 0.5
	return Vector2i(int(gx), int(gy))
