extends Node2D
@onready var tooltip = $CanvasLayer/Node2D/Sprite2D/tooltip
@onready var sprite = $CanvasLayer/Node2D/Sprite2D
func _ready():
	sprite.global_position = Vector2(976.0, 500)


func moveTo(pos: Vector2):
	await get_tree().create_timer(1).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "global_position", pos,1)
	
func setVisuals(text: String, image: CompressedTexture2D):
	sprite.texture = image
	tooltip.tooltip_text = text
