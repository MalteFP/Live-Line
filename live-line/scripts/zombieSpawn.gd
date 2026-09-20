extends Node2D
var enemy = preload("res://scenes/enemy.tscn")
var maxEnemeies = 10
var movesSinceSpawn = 0
var bonusScalingMult = 1

var anyFusePickedUp = false
var hasAnyEnemyDied = false
var tutorial: bool = false

var zombiesKill = 0

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	$tutorial/tutorialRect.global_position = Vector2(426,648)
	if tutorial:
		$Node2D/Button.visible = false
		var tween = get_tree().create_tween()
		tween.tween_property($tutorial/tutorialRect,"global_position",Vector2(426,548),2)
		var settings = LabelSettings.new()
		settings.font_size = 24
		$tutorial/tutorialRect/Label.label_settings = settings
		var up = InputMap.action_get_events("up")[0].as_text().split(" ")[0]
		var down = InputMap.action_get_events("down")[0].as_text().split(" ")[0]
		var left = InputMap.action_get_events("left")[0].as_text().split(" ")[0]
		var right = InputMap.action_get_events("right")[0].as_text().split(" ")[0]
		var attack = InputMap.action_get_events("attack")[0].as_text().split(" ")[0]
		$tutorial/tutorialRect/Label.text = "A bomb is strapped to your back. Use " + up + left + down + right  + " to move and " + attack + " to attack"

func spawnZombie():
	if get_tree().get_node_count_in_group("enemy") >= maxEnemeies:
		return
	if randf() >= int(3/(movesSinceSpawn + 1)): 
		movesSinceSpawn = 0
		
		while true:
			var point = player.get_node("player").global_position + Vector2(
	randi_range(-10, 10) * 16,
	randi_range(-10, 10) * 16
)

			if is_point_inside(point):
				continue
			var randomBoost = (player.level + 1) * bonusScalingMult
			var e = enemy.instantiate()
			add_child(e)
			e.body.global_position = point - Vector2(8,8)
			e.sprite.global_position = point
			e.setup(1,
			randomBoost,
			randomBoost,
			Vector2(7,10),
			 15,
			load("res://textures/sprites/enemies/zombie/zombieSpriteFrames.tres"),
			load("res://Audio/freesound_community-zombie-6851.mp3"),
			load("res://Audio/freesound_community-zombie-bite-96528.mp3")
			)
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

func zombieKilled():
	zombiesKill += 1
	if zombiesKill >= 100 and not Saver.achievements["zombieKiller"]:
		Saver.achievements["zombieKiller"] = true
		Saver.saveGame()
