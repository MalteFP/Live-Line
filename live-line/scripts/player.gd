extends Node2D

@onready var fuseController = $FuseController
@onready var body = $player
@onready var sprite = $AnimatedSprite2D
var movementBlocked = false
var tilSize = 16

var lastMove = "up"
var movementTween: Tween

var isMoveReady = true
func _ready() -> void:
	pass
	
	
func _unhandled_input(event: InputEvent) -> void:
	if movementBlocked or not isMoveReady:
		return
	
	if Input.is_action_just_pressed("attack"):
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
	movementBlocked = true
	var particels = $player/explosionParticles
	var cam = $player/Camera2D
	particels.emitting = true
	sprite.play("ash")
	var tween = get_tree().create_tween()
	tween.tween_property(cam,"zoom",Vector2(10,10),1)
	await get_tree().create_timer(1).timeout
	particels.emitting = false
	await get_tree().create_timer(1.5).timeout
	$lossScene.death()

func attack():
	get_node("Sword/Sprite2D").timeInAttack = 0
	get_node("Sword/Sprite2D").isAttacking = true
	get_node("Sword/Sprite2D").visible = true
	await get_tree().create_timer((0.65)).timeout
	get_node("Sword/Sprite2D").visible = false
	get_node("Sword/Sprite2D").isAttacking = false
	
func do_move(vector: Vector2, dir: String):
	var tween = get_tree().create_tween()
	if movementTween and movementTween.is_running():
		movementTween.custom_step(1)
	fuseController.playerMoved(dir)
	lastMove = dir
	tween.tween_property(sprite,"global_position", body.position + vector, 0.2)
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
	
	
