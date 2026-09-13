extends Area2D


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "player":
		body.get_parent().get_node("FuseController").notLayedWire += 10
		get_parent().queue_free()
