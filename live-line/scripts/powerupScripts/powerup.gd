extends Node2D

var icon = preload("res://scenes/powerup_icon.tscn")
var collectedPowerups = []

func apply(object: Object, property: String, value, absolute: bool, description: String, Icon: CompressedTexture2D):
	if absolute:
		object.set(property, value)
	else:
		object.set(property, object.get(property) + value)

	print (str(property) + " " + str(value))

	var power = icon.instantiate()
	await get_tree().create_timer(14).timeout
	add_child(power)
	power.setVisuals(description, Icon)
	collectedPowerups.append(power)
	power.moveTo(Vector2(collectedPowerups.size() * 48, 32))
	
