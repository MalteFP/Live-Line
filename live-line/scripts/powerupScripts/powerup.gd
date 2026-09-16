extends Node2D

var icon = preload("res://scenes/powerup_icon.tscn")
var collectedPowerups = []

func apply(object: Object, property: String, value: float, absolute: bool):
	if absolute:
		object.set(property, value)
	else:
		object.set(property, object.get(property) + value)
	var power = icon.instantiate()
	await get_tree().create_timer(15).timeout
	add_child(power)
	collectedPowerups.append(power)
	power.moveTo(Vector2(collectedPowerups.size() * 48, 32))
