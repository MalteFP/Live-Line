extends Node2D
@onready var label = $CanvasLayer2/Label
@onready var sprite = $CanvasLayer/Node2D/Sprite2D
func _ready():
	sprite.global_position = Vector2(976.0, 400)
	label.global_position = Vector2(976.0, 400)
	label.visible = true


func _on_area_2d_mouse_entered() -> void:
	label.visible = true


func _on_area_2d_mouse_exited() -> void:
	label.visible = false


func moveTo(pos: Vector2):
	await get_tree().create_timer(1).timeout
	label.visible = false
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "global_position", pos,1)
	label.global_position = pos + Vector2(0,30)
	
func setVisuals(text: String, image: CompressedTexture2D):
	sprite.texture = image
	label.text = text
