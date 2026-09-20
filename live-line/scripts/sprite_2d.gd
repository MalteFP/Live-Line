extends AnimatedSprite2D
var isAttacking = false
var timeInAttack = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass# Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if isAttacking:
		print(str(scale.y))
		print(str($"..".scale.y))
		global_position = $"../../player/CollisionShape2D".global_position + Vector2((8+8*$"..".scale.y)*sin(20*timeInAttack),(8+8*$"..".scale.y)*cos(20*timeInAttack))
		timeInAttack += delta
		rotate(get_angle_to($"../../player".global_position)-PI)
		
