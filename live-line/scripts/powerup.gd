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
	add_child(power)
	power.setVisuals(description, Icon)
	power.moveTo(Vector2((collectedPowerups.size() % 8) * 48 + 32,floori(collectedPowerups.size() / 8) * 48 + 32))
	collectedPowerups.append(power)
	
