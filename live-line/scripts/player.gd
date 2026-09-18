extends Node2D

@onready var fuseController = $FuseController
@onready var body = $player
@onready var sprite = $AnimatedSprite2D
var movementBlocked = false
var tilSize = 16

var damage = 1
var lastMove = "up"
var movementTween: Tween
var level
var xpTowardsLevel
var xpForLevel
var isMoveReady = true
var fuseMult 
var hasMoved = false


func _ready() -> void:
	level = 0
	xpForLevel = 10
	xpTowardsLevel = 0
	fuseMult = 1
	$Sword.scale = Vector2(1,1)
	$AnimatedSprite2D/PointLight2D.texture_scale = 6
	$"..".bonusScalingMult = 1
	ScoreHolder.totalFuse = 0
	ScoreHolder.timeSpent = 0
func _process(_delta: float) -> void:
	if xpTowardsLevel >= xpForLevel:
		var label = get_tree().get_first_node_in_group("tutorialLabel")
		var settings = LabelSettings.new()
		settings.font_size = 20
		label.label_settings = settings
		label.text = "When you level up you get to spin the wheel,\n click spin and get a random power up"
		xpTowardsLevel -= xpForLevel
		level += 1
		$"../Node2D/levelUpScreen".levelUp()
		xpForLevel += 10
		print("Level up: " + str(level))
	if damage < 1:
		damage = 1
	if $player/BackgroundMusic.playing == false:
		$player/BackgroundMusic.play()
	
func _unhandled_input(_event: InputEvent) -> void:
	if movementBlocked or not isMoveReady:
		return
	
	if Input.is_action_just_pressed("attack"):
		isMoveReady = false
		attack()
		
	elif Input.is_action_just_pressed("up"):
		if not is_point_inside(body.global_position + Vector2(0, -16)):
			isMoveReady = false
			do_move(Vector2(0, -16), "up")

	elif Input.is_action_just_pressed("down"):
		if not is_point_inside(body.global_position + Vector2(0, 16)):
			isMoveReady = false
			do_move(Vector2(0, 16), "down")

	elif Input.is_action_just_pressed("left"):
		if not is_point_inside(body.global_position + Vector2(-16, 0)):
			isMoveReady = false
			do_move(Vector2(-16, 0), "left")

	elif Input.is_action_just_pressed("right"):
		if not is_point_inside(body.global_position + Vector2(16, 0)):
			isMoveReady = false
			do_move(Vector2(16, 0), "right")


	


func is_point_inside(point: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var paras = PhysicsPointQueryParameters2D.new()
	paras.position = point + Vector2(0,-4)
	paras.collision_mask = 1
	var result = space_state.intersect_point(paras)
	
	return result.size() > 0
	
func updateSprite():
	if not movementTween or movementTween and not movementTween.is_running():
		if lastMove == "up":
			body.scale = Vector2(1,1)
			sprite.play("idleBack")
		elif lastMove == "down":
			body.scale = Vector2(1,1)
			sprite.play("idleFront")
		elif lastMove == "right":
			body.scale = Vector2(-1,1)
			sprite.play("idleSide")
		elif lastMove == "left":
			body.scale = Vector2(1,1)
			sprite.play("idleSide")



func explode():
	var tween = get_tree().create_tween()
	tween.tween_property($player/BackgroundMusic, "volume_db", -60, 1)
	$player/Explosion.play()
	movementBlocked = true
	var particels = $player/explosionParticles
	var cam = $player/Camera2D
	particels.emitting = true
	sprite.play("ash")
	tween.tween_property(cam,"zoom",Vector2(10,10),1)
	await get_tree().create_timer(1).timeout
	particels.emitting = false
	await get_tree().create_timer(1.5).timeout
	$lossScene.death()

func attack():
	$player/SwordSwing.play()
	get_node("Sword/Sprite2D").timeInAttack = 0
	get_node("Sword/Sprite2D").isAttacking = true
	get_node("Sword/Sprite2D").visible = true
	await get_tree().create_timer((0.65/2)).timeout
	get_node("Sword/Sprite2D").visible = false
	get_node("Sword/Sprite2D").isAttacking = false
	do_move(Vector2(0,0),"none")
	fuseController.playerAttacked()
	
func do_move(vector: Vector2, dir: String):
	if hasMoved == false:
		hasMoved = true
		var settings = LabelSettings.new()
		settings.font_size = 24
		$"../tutorial/tutorialRect/Label".label_settings = settings
		$"../tutorial/tutorialRect/Label".text = "But watch out, each time \n you move your fuse burns \n and mosters attack"
	if dir != "none":
		var tween = get_tree().create_tween()
		if movementTween and movementTween.is_running():
			movementTween.custom_step(1)
		fuseController.playerMoved(dir)
		lastMove = dir
		tween.tween_property(sprite,"global_position", body.position + vector, 0.2)
		$player/Footsteps.play()
		body.global_position += vector
		movementTween = tween
		
		
		if dir == "up":
			sprite.scale = Vector2(1,1)
			sprite.play("walkingBack")
		elif dir == "down":
			sprite.scale = Vector2(1,1)
			sprite.play("walkingFront")
		elif dir == "right":
			sprite.scale = Vector2(-1,1)
			sprite.play("walkingSide")
		elif dir == "left":
			sprite.scale = Vector2(1,1)
			sprite.play("walkingSide")
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.process()
	get_parent().spawnZombie()
	isMoveReady = true
	
