extends Node2D

@onready var fuseController = $FuseController
@onready var body = $player
@onready var sprite = $player/AnimatedSprite2D


var lastMove = "up"

var movementTween: Tween
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement()
	updateSprite()

func movement():

	var pos = body.global_position

	
	if Input.is_action_just_pressed("attack"):
		pass
	elif Input.is_action_just_pressed("up") and not is_point_inside(pos + Vector2(0,-16)):
		sprite.play("walkingBack")
		var tween = get_tree().create_tween()
		if movementTween and movementTween.is_running():
			movementTween.custom_step(1)
		fuseController.playerMoved("up")
		lastMove = "up"
		tween.tween_property(body,"position", body.position + Vector2(0,-16), 0.2)
		movementTween = tween
	elif Input.is_action_just_pressed("down") and not is_point_inside(pos + Vector2(0,16)):
		sprite.play("walkingFront")
		var tween = get_tree().create_tween()
		if movementTween and movementTween.is_running():
			movementTween.custom_step(1)
		fuseController.playerMoved("down")
		lastMove = "down"
		tween.tween_property(body,"position", body.position + Vector2(0,16), 0.2)
		movementTween = tween
	elif Input.is_action_just_pressed("left") and not is_point_inside(pos + Vector2(-16,0)):
		sprite.play("walkingSide")
		var tween = get_tree().create_tween()
		if movementTween and movementTween.is_running():
			movementTween.custom_step(1)
		fuseController.playerMoved("left")
		lastMove = "left"
		tween.tween_property(body,"position", body.position + Vector2(-16,0), 0.2)
		movementTween = tween
	elif Input.is_action_just_pressed("right") and not is_point_inside(pos + Vector2(16,0)):
		sprite.play("walkingSide")
		body.scale = Vector2(-1,1)
		var tween = get_tree().create_tween()
		if movementTween and movementTween.is_running():
			movementTween.custom_step(1)
		fuseController.playerMoved("right")
		lastMove = "right"
		tween.tween_property(body,"position", body.position + Vector2(16,0), 0.2)
		movementTween = tween
	


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
	
