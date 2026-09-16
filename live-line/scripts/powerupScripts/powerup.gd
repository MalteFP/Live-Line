class_name Powerup

func apply(object: Object, property: String, value: float, absolute: bool):
	if absolute:
		object.set(property, value)
	else:
		object.set(property, object.get(property) + value)
