extends Node2D

var degreePerSlice = 360/8
var colors = ["yellow", "green", "red", "dark green", "yellow", "green", "red", "green"]


func levelUp():
	var spin = randf_range(0, 360)
	var color = colors[floori(spin/degreePerSlice)]
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/Node2D, "global_position",Vector2(1152/2,-50),1)
	tween.chain().tween_property($CanvasLayer/Node2D/wheel, "rotation", deg_to_rad(3600 + spin), 10).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property($CanvasLayer/Node2D, "global_position",Vector2(1152/2,-300),1)
	

	
	
	
