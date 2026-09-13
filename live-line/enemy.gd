extends Node2D
class_name enemy

var type: String
var damage: int
var speed = 1
var grid := AStarGrid2D.new()
var range = 5

@onready var sprite = $Sprite2D

func process():
	walk()

func _ready():
	grid.cell_size = Vector2(16,16)
	grid.diagonal_mode = 1
	grid.update()

func walk():
	var playerPos = get_tree().get_first_node_in_group("player").get_node("player").global_position
	grid.region = Rect2i(
	int(global_position.x / 16) - range,
	int(global_position.y / 16) - range,
	range * 2,
	range * 2
	)
	grid.update()
	var goal = Vector2i(floori(playerPos.x/16), floori(playerPos.y/16))
	if grid.region.has_point(goal):
		var start = Vector2i(floori(global_position.x/16), floori(global_position.y/16))
		
		var path = grid.get_id_path(start, goal)
		
		global_position = path[speed] * 16





func distanceToPlayer() -> float:
	return (sprite.global_position - (get_tree().get_first_node_in_group("player").get_node("player").global_position)).length()


func updateCollision():
	for x in range(grid.region.size.x):
		for y in range(grid.region.size.y):
			var cell = Vector2i(grid.region.position.x + x, grid.region.position.y + y)
			grid.set_point_solid(cell, is_cell_blocked(cell))


func is_cell_blocked(cell: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var paras = PhysicsPointQueryParameters2D.new()
	paras.position = cell * 16 + Vector2(8,8)
	var result = space_state.intersect_point(paras)
	return result.size() > 0
