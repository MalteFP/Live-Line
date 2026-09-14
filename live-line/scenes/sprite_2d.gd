extends AnimatedSprite2D
var isAttacking = false
var timeInAttack = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isAttacking:
		global_position = $"../../player".global_position + Vector2(sin(timeInAttack*10),cos(timeInAttack*10))*16
		timeInAttack += delta
		rotate(get_angle_to($"../../player".global_position)-PI)
		
