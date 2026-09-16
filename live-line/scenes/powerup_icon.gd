extends Node2D
@onready var label = $CanvasLayer/Node2D/Label
@onready var sprite = $CanvasLayer/Node2D/Sprite2D
func _ready():
	sprite.global_position = Vector2(1152/2, 150)
	label.global_position = Vector2(1152/2, 150)
	label.visible = true


func _on_area_2d_mouse_entered() -> void:
	label.visible = true


func _on_area_2d_mouse_exited() -> void:
	label.visible = false


func moveTo(position: Vector2):
	await get_tree().create_timer(1).timeout
	label.visible = false
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "global_position", position,1)
	label.global_position = position + Vector2(0,20)
	
func setVisuals(text: String, image: Image):
	sprite.texture = image
	label.text = text
