extends Node2D

var fusePos = []
var firePos: Vector2

func playerMoved(direction: Vector2):
	fusePos.pop_back().queue_free()
	
