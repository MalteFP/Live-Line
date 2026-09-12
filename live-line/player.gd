extends Node2D

var fuseLength = 10
@onready var fuseController = $FuseController
@onready var body = $CharacterBody2D
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement()


func movement():
	var pos = body.global_position
	if Input.is_action_just_pressed("attack"):
		pass
	elif Input.is_action_just_pressed("up") and not is_point_inside(pos + Vector2(0,-16)):
		fuseController.playerMoved("up")
		body.position += Vector2(0,-16)
		
	elif Input.is_action_just_pressed("down") and not is_point_inside(pos + Vector2(0,16)):
		fuseController.playerMoved("down")
		body.position += Vector2(0,16)
	elif Input.is_action_just_pressed("left") and not is_point_inside(pos + Vector2(-16,0)):
		fuseController.playerMoved("left")
		body.position += Vector2(-16,0)
	elif Input.is_action_just_pressed("right") and not is_point_inside(pos + Vector2(16,0)):
		fuseController.playerMoved("right")
		body.position += Vector2(16,0)
		


func is_point_inside(point: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var paras = PhysicsPointQueryParameters2D.new()
	paras.position = point
	var result = space_state.intersect_point(paras)
	return result.size() > 0
