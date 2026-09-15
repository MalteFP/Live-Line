extends Node2D
var amount = 10


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.get_parent().get_node("FuseController").notLayedWire += amount
		get_tree().get_first_node_in_group("player").xpTowardsLevel += amount
		ScoreHolder.totalFuse += amount
		queue_free()
	
