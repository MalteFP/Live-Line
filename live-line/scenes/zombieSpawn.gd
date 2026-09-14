extends Node2D

var zombie = preload("res://scenes/zombie.tscn")

func spawnZombie():
	var z = zombie.instantiate()
	z.global_position = Vector2(randi_range(-10, 10) * 16, randi_range(-10, 10) * 16)
	add_child(z)
