extends Control
var maxHealth = 100
var currentHealth


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentHealth = maxHealth
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_node("CanvasLayer/HealthBarText").text = str(int(currentHealth)) + "/" + str(maxHealth)
	get_node("CanvasLayer/HealthBarBar").scale = Vector2(currentHealth/maxHealth*15,5)
	get_node("CanvasLayer/HealthBarBar").position = Vector2(currentHealth/maxHealth*15*16/2,40)
	await get_tree().create_timer(1.0).timeout 
	currentHealth -= 1*delta
