extends Node2D

class_name Enemy

var speed = 1
var drop = Vector2(1000, 1000)
var grid := AStarGrid2D.new()
var cell_size := Vector2i(16, 16)
var detectRange := 30
var movementTween: Tween
var debug = false
var damage = 2
var dead = false
var health = 0
var hitThisTurn = false

var blocks = []
var notblocks = []
var pathWay = []
var playerblock: Vector2
@onready var body = $Node2D
@onready var sprite = $sprite
@onready var passiveSounds = $EnemyPassiveSound
@onready var attackSounds = $EnemyAttackSound

func setup(spd: int, hp: float, dmg: float, dropRange: Vector2, sightRange: int, spriteFrames: SpriteFrames, passiveSoundEffect: AudioStreamMP3, attackSoundEffect: AudioStreamMP3) -> void:
	self.speed = spd
	self.health = hp
	self.drop = dropRange
	self.detectRange = sightRange
	self.damage = dmg
	self.sprite.set_sprite_frames(spriteFrames)
	self.passiveSounds.stream = passiveSoundEffect
	self.attackSounds.stream = attackSoundEffect

func process():
	checkHealth()
	build_grid()
	queue_redraw()
	hitThisTurn = true


func checkHealth():
	if health > 0:
		return
	death()
func build_grid():
	grid = AStarGrid2D.new()
	blocks = []
	notblocks = []
	
	var center_tile := Vector2i(body.global_position.x / 16, body.global_position.y / 16)
	grid.region = Rect2i(center_tile - Vector2i(detectRange, detectRange),
						 Vector2i(detectRange * 2 + 1, detectRange * 2 + 1))

	grid.cell_size = cell_size
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.update()

	var space_state := get_world_2d().direct_space_state

	var shape := RectangleShape2D.new()
	shape.extents = Vector2(1, 1)

	for x in grid.region.size.x:
		for y in grid.region.size.y:
			var cell := Vector2i(grid.region.position.x + x, grid.region.position.y + y)
			var world_pos := Vector2(cell.x * 16 + 8, cell.y * 16 + 8)

			var query := PhysicsShapeQueryParameters2D.new()
			query.shape = shape
			query.transform = Transform2D(0, world_pos + Vector2(0,6))
			query.collision_mask = 0b10
			query.exclude = [$Node2D/StaticBody2D]
	

			var result := space_state.intersect_shape(query)
			var blocked := result.size() > 0
			
			if blocked:
				blocks.append(Vector2(world_pos))
			else:
				notblocks.append(Vector2(world_pos))
			grid.set_point_solid(cell, blocked)

	var player := get_tree().get_first_node_in_group("player").get_node("player")
	var goal := Vector2i(ceil(player.global_position.x / 16) - 1, ceil(player.global_position.y / 16) - 1)
	if grid.is_in_bounds(goal.x,goal.y):
		grid.set_point_solid(goal, false)
	grid.update()
	walk()



func _draw() -> void:
	if not debug:
		return
	for block in blocks:
		draw_rect(Rect2(block - global_position,Vector2(8,8)),Color(1.0, 0.0, 0.0, 1.0))
	for block in notblocks:
		draw_rect(Rect2(block - global_position,Vector2(8,8)),Color(0.0, 1.0, 0.0, 1.0))
	for block in pathWay:
		draw_rect(Rect2(Vector2(block) * 16 - global_position,Vector2(8,8)),Color(1.0, 1.0, 0.0, 1.0))
	pathWay = []
	draw_rect(Rect2(Vector2(playerblock) - global_position,Vector2(8,8)),Color(0.0, 0.0, 1.0, 1.0))

func walk():
	if dead:
		return
	var doSoundEffect = randf_range(0,1)
	if doSoundEffect > 0.8:
		$EnemyPassiveSound.play()
	var player := get_tree().get_first_node_in_group("player").get_node("player")
	playerblock = player.global_position
	var start := Vector2i(body.global_position.x / 16, body.global_position.y / 16)
	var goal := Vector2i(ceil(player.global_position.x / 16) - 1, ceil(player.global_position.y / 16) - 1)
	var center_tile := Vector2i(body.global_position.x / 16, body.global_position.y / 16)
	if (goal-center_tile).length() <= 1.5:
			$"../Player/FuseController".takeDamage(damage)
			$EnemyAttackSound.play()
	if not grid.region.has_point(goal):
		print("respawn")
		queue_free()
		return

	var path = grid.get_id_path(start, goal)
	for p in path: 
		pathWay.append(p)
	if path.size() < 3:
		return
	path.pop_front()
	path.pop_back()
	if movementTween and movementTween.is_running():
		movementTween.custom_step(1)
	var next_tile
	if path.size() < speed:
		next_tile = path.front()
	else:
		next_tile = path[speed - 1]
	updateAnimation((body.global_position - Vector2(next_tile * 16)).normalized())
	var tween = get_tree().create_tween()
	tween.tween_property(sprite,"global_position",Vector2(next_tile * 16) + Vector2(8,8),0.2)
	body.global_position = Vector2(next_tile * 16)
	movementTween = tween
	

	


func updateAnimation(vector: Vector2):
	if vector == Vector2(1.0, 0.0):
		sprite.play("walkingSide")
		sprite.scale = Vector2(1,1)
	elif vector == Vector2(-1.0, 0.0):
		sprite.play("walkingSide")
		sprite.scale = Vector2(-1,1)
	elif vector == Vector2(0.0, -1.0):
		sprite.play("walkingFront")
		sprite.scale = Vector2(1,1)
	elif vector == Vector2(0.0, 1.0):
		sprite.play("walkingBack")
		sprite.scale = Vector2(1,1)

func death():
	var world = get_tree().get_first_node_in_group("world")
	world.zombieKilled()
	if world.hasAnyEnemyDied == false:
		world.hasAnyEnemyDied = true
		var settings = LabelSettings.new()
		settings.font_size = 30
		get_tree().get_first_node_in_group("tutorialLabel").label_settings = settings
		get_tree().get_first_node_in_group("tutorialLabel").text = "Killing enemies drops fuse, \n walk over them to pick it up."
	dead = true
	$Node2D/explosionParticles.emitting = true
	var drops = preload("res://scenes/itemWire.tscn")
	var fuse = drops.instantiate()
	fuse.amount = randi_range(drop.x, drop.y)
	fuse.global_position = body.global_position
	get_parent().add_child(fuse)
	await get_tree().create_timer(0.1).timeout
	$Node2D/explosionParticles.emitting = false
	sprite.visible = false
	await get_tree().create_timer(1).timeout
	queue_free()
