extends Node2D
var maxEnemeies = 10
var zombie = preload("res://scenes/zombie.tscn")
var movesSinceSpawn = 0
@onready var player = get_tree().get_first_node_in_group("player").get_node("player")

func spawnZombie():
	if get_tree().get_node_count_in_group("enemy") >= maxEnemeies:
		return
	if randf() >= 5/(movesSinceSpawn + 1): 
		movesSinceSpawn = 0
		var z = zombie.instantiate()
		while true:
			var point = Vector2(randi_range(-10, 10) * 16 + 8, randi_range(-10, 10) * 16 + 8) + player.global_position
			if is_point_inside(point):
				print("new")
				continue
			z.global_position = point
			add_child(z)
			break
	else:
		movesSinceSpawn += 1


func is_point_inside(point: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var paras = PhysicsPointQueryParameters2D.new()
	paras.position = point
	paras.collision_mask = 1
	var result = space_state.intersect_point(paras)
	
	return result.size() > 0
