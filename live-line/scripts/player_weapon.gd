extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("enemyhitbox"):
		body.get_parent().get_parent().health -= player.damage
		var tweenHue = $"../AnimatedSprite2D/PointLight2D".create_tween().set_parallel(true)
		tweenHue.tween_property(body.get_parent().get_parent().get_node("sprite"),"self_modulate", Color.RED, 0.3)
		tweenHue.chain().tween_property(body.get_parent().get_parent().get_node("sprite"),"self_modulate", Color.WHITE, 0.3)
