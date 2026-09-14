extends Node2D

@onready var fuseController = $FuseController
@onready var body = $player
@onready var sprite = $AnimatedSprite2D
var movementBlocked = false
var tilSize = 16

var lastMove = "up"

var movementTween: Tween
func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	movement()
	updateSprite()

func movement():
	if movementBlocked:
		return
	var actionTaked = false
	var pos = body.global_position
	
	if Input.is_action_just_pressed("attack"):
		actionTaked = true
		fuseController.playerAttacked()
	elif Input.is_action_just_pressed("up") and not is_point_inside(pos + Vector2(0,-16)):
		actionTaked = true
		sprite.play("walkingBack")
		var tween = get_tree().create_tween()
		if movementTween and movementTween.is_running():
			movementTween.custom_step(1)
		fuseController.playerMoved("up")
		lastMove = "up"
		tween.tween_property(sprite,"global_position", body.position + Vector2(0,-16), 0.2)
		body.global_position += Vector2(0,-16)
		movementTween = tween
	elif Input.is_action_just_pressed("down") and not is_point_inside(pos + Vector2(0,16)):
		actionTaked = true
		sprite.play("walkingFront")
		var tween = get_tree().create_tween()
		if movementTween and movementTween.is_running():
			movementTween.custom_step(1)
		fuseController.playerMoved("down")
		lastMove = "down"
		tween.tween_property(sprite,"global_position", body.position + Vector2(0,16), 0.2)
		body.global_position += Vector2(0,16)
		movementTween = tween
	elif Input.is_action_just_pressed("left") and not is_point_inside(pos + Vector2(-16,0)):
		actionTaked = true
		sprite.play("walkingSide")
		sprite.scale = Vector2(1,1)
		var tween = get_tree().create_tween()
		if movementTween and movementTween.is_running():
			movementTween.custom_step(1)
		fuseController.playerMoved("left")
		lastMove = "left"
		tween.tween_property(sprite,"global_position", body.position + Vector2(-16,0), 0.2)
		body.global_position += Vector2(-16,0)
		movementTween = tween
	elif Input.is_action_just_pressed("right") and not is_point_inside(pos + Vector2(16,0)):
		actionTaked = true
		sprite.play("walkingSide")
		sprite.scale = Vector2(-1,1)
		var tween = get_tree().create_tween()
		if movementTween and movementTween.is_running():
			movementTween.custom_step(1)
		fuseController.playerMoved("right")
		lastMove = "right"
		tween.tween_property(sprite,"global_position", body.position + Vector2(16,0), 0.2)
		body.global_position += Vector2(16,0)
		movementTween = tween
	if actionTaked:
		var enemies = get_tree().get_nodes_in_group("enemy")
		for enemy in enemies:
			enemy.process()


func is_point_inside(point: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var paras = PhysicsPointQueryParameters2D.new()
	paras.position = point
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
	$player/ash.visible = true
	sprite.visible = false
	var tween = get_tree().create_tween()
	tween.tween_property(cam,"zoom",Vector2(10,10),1)
	await get_tree().create_timer(1).timeout
	particels.emitting = false
	await get_tree().create_timer(1.5).timeout
	$lossScene.death()

	
	
	
	
	
