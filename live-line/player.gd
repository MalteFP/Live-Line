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
	if Input.is_action_just_pressed("attack"):
		TurnQueueHolder.playerTookTurn()
	elif Input.is_action_just_pressed("up"):
		body.position -= Vector2(0,16)
		TurnQueueHolder.playerTookTurn()
	elif Input.is_action_just_pressed("down"):
		body.position -= Vector2(0,-16)
		TurnQueueHolder.playerTookTurn()
	elif Input.is_action_just_pressed("left"):
		body.position -= Vector2(16,0)
		TurnQueueHolder.playerTookTurn()
	elif Input.is_action_just_pressed("right"):
		body.position -= Vector2(-16,0)
		TurnQueueHolder.playerTookTurn()
