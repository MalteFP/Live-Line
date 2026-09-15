extends Control
var rng = RandomNumberGenerator.new()
var rollQuality

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Vector2(576,-400)
	get_node("RigidBody2D").angular_damp = 2
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func levelUp():
	var tween = get_tree().create_tween()
	show()
	tween.tween_property($".", "position", Vector2(576,16), 1.0)
	

	
	
	var levelUpRoll = rng.randf_range(0,1)
	if levelUpRoll <= 0.125:
		get_node("RigidBody2D").angular_velocity = 153.6
		rollQuality = "red"
	elif levelUpRoll <= 0.250:
		get_node("RigidBody2D").angular_velocity = 160.08
		rollQuality = "red"
	elif levelUpRoll <= 0.375:
		get_node("RigidBody2D").angular_velocity = 150.25
		rollQuality = "yellow"
	elif levelUpRoll <= 0.500:
		get_node("RigidBody2D").angular_velocity = 156.8
		rollQuality = "yellow"
	elif levelUpRoll <= 0.625:
		get_node("RigidBody2D").angular_velocity = 151.9
		rollQuality = "lgreen"
	elif levelUpRoll <= 0.750:
		get_node("RigidBody2D").angular_velocity = 155.15
		rollQuality = "lgreen"
	elif levelUpRoll <= 0.875:
		get_node("RigidBody2D").angular_velocity = 158.4
		rollQuality = "lgreen"
	elif levelUpRoll <= 1:
		get_node("RigidBody2D").angular_velocity = 161.67
		rollQuality = "dgreen"
	print(str(rollQuality))
	await get_tree().create_timer(10).timeout
	tween.tween_property($".", "position", Vector2(576,-150), 1.0)
	hide()
	
