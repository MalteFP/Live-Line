extends Node
var totalFuse = 0
var timeSpent = 0

func _process(delta: float) -> void:
	timeSpent += delta
