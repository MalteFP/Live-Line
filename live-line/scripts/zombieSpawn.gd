extends Node2D
var enemy = preload("res://scenes/enemy.tscn")
var maxEnemeies = 10
var movesSinceSpawn = 0
var bonusScalingMult = 1

var tutorial: bool = false


@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	if tutorial:
		$Node2D/Button.visible = false
	

func spawnZombie():
	if get_tree().get_node_count_in_group("enemy") >= maxEnemeies:
		return
	if randf() >= 3/(movesSinceSpawn + 1): 
		movesSinceSpawn = 0
		
		while true:
			var point = player.get_node("player").global_position + Vector2(
	randi_range(-5, 5) * 16,
	randi_range(-5, 5) * 16
)

			if is_point_inside(point):
				continue
			var randomBoost = randf_range(1,player.level) * bonusScalingMult
			var e = enemy.instantiate()
			add_child(e)
			e.body.global_position = point - Vector2(8,8)
			e.sprite.global_position = point - Vector2(8,8)
			e.setup(randomBoost,
			randomBoost,
			randomBoost,
			Vector2(7,10),
			 15,
			load("res://textures/sprites/enemies/zombie/zombieSpriteFrames.tres"))
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
