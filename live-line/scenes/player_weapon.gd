extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemyhitbox"):
		body.get_parent().get_parent().health -= player.damage
		body.get_parent().get_parent().hitThisTurn
		print(body.get_parent().get_parent().health)
