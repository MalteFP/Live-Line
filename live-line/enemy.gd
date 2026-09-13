extends Node2D
class_name enemy

var type: String
var damage: int
var speed = 1
var grid := AStarGrid2D.new()
var range = 100

@onready var sprite = $Sprite2D

func process():
	walk()


func _ready():
	grid.cell_size = Vector2(16,16)
	
	grid.diagonal_mode = 1
	grid.update()


func walk():
	var distance = distanceToPlayer()

	if distance <= range * 16:

		var start = Vector2i(
			floori(sprite.global_position.x / 16),
			floori(sprite.global_position.y / 16)
		)

		var playerPos = get_tree().get_first_node_in_group("player").get_node("player").global_position

		var goal = Vector2i(
			floori(playerPos.x / 16),
			floori(playerPos.y / 16)
		)

		# Make a region large enough to contain both points
		var min_x = mini(start.x, goal.x)
		var min_y = mini(start.y, goal.y)
		var max_x = maxi(start.x, goal.x)
		var max_y = maxi(start.y, goal.y)

		var padding = 2

		grid.region = Rect2i(
			min_x - padding,
			min_y - padding,
			max_x - min_x + 1 + padding * 2,
			max_y - min_y + 1 + padding * 2
		)

		grid.update()
		updateCollision()

		var moves = grid.get_id_path(start, goal)

		if moves.size() <= speed:
			return

		var tween = get_tree().create_tween()

		tween.tween_property(
			sprite,
			"global_position",
			Vector2(moves[speed]) * 16 + Vector2(8, 8),
			0.2
		)


func distanceToPlayer() -> float:
	return (sprite.global_position - (get_tree().get_first_node_in_group("player").get_node("player").global_position)).length()


func updateCollision():
	for x in range(grid.region.size.x):
		for y in range(grid.region.size.y):
			var cell = Vector2i(
				grid.region.position.x + x,
				grid.region.position.y + y
			)

			grid.set_point_solid(cell, is_cell_blocked(cell))


func is_cell_blocked(cell: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var paras = PhysicsPointQueryParameters2D.new()
	paras.position = cell * 16 + Vector2(8,8)
	var result = space_state.intersect_point(paras)
	return result.size() > 0
