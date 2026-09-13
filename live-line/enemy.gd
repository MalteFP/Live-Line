extends Node2D
class_name Enemy

var grid := AStarGrid2D.new()
var cell_size := Vector2i(16, 16)
var range := 10

var blocked_cells: Array[Vector2i] = []
var not_blocked_cells: Array[Vector2i] = []

func _ready():
	build_grid()

func process():
	build_grid()
	walk()


func build_grid():
	blocked_cells.clear()
	not_blocked_cells.clear()

	var center_tile := Vector2i(global_position.x / 16, global_position.y / 16)
	grid.region = Rect2i(center_tile - Vector2i(range, range),
						 Vector2i(range * 2 + 1, range * 2 + 1))

	grid.cell_size = cell_size
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.update()

	var space_state := get_world_2d().direct_space_state

	# FIX: tiny shape instead of full tile
	var shape := RectangleShape2D.new()
	shape.extents = Vector2(2, 2)

	for x in grid.region.size.x:
		for y in grid.region.size.y:
			var cell := Vector2i(grid.region.position.x + x, grid.region.position.y + y)
			var world_pos := Vector2(cell.x * 16 + 8, cell.y * 16 + 8)

			var query := PhysicsShapeQueryParameters2D.new()
			query.shape = shape
			query.transform = Transform2D(0, world_pos)

			var result := space_state.intersect_shape(query)
			var blocked := result.size() > 0

			grid.set_point_solid(cell, blocked)

			if blocked:
				blocked_cells.append(cell)
			else:
				not_blocked_cells.append(cell)
	var player := get_tree().get_first_node_in_group("player").get_node("player")
	var goal := Vector2i(player.global_position.x / 16, player.global_position.y / 16)
	if grid.is_in_bounds(goal.x,goal.y):
		grid.set_point_solid(goal, false)
	grid.update()
	
	queue_redraw()




func _draw():
	for cell in blocked_cells:
		var world_pos := Vector2(cell.x * 16, cell.y * 16)
		var local_pos := world_pos - global_position
		draw_rect(Rect2(local_pos, Vector2(8, 8)), Color(1, 0, 0, 0.4))

	for cell in not_blocked_cells:
		var world_pos := Vector2(cell.x * 16, cell.y * 16)
		var local_pos := world_pos - global_position
		draw_rect(Rect2(local_pos, Vector2(8, 8)), Color(0.108, 0.647, 0.0, 0.4))


func walk():
	var player := get_tree().get_first_node_in_group("player").get_node("player")

	var start := Vector2i(global_position.x / 16, global_position.y / 16)
	var goal := Vector2i(player.global_position.x / 16, player.global_position.y / 16)
	if not grid.region.has_point(goal):
		return

	var path := grid.get_id_path(start, goal)

	if path.size() < 2:
		return

	var next_tile := path[1]
	global_position = next_tile * 16
