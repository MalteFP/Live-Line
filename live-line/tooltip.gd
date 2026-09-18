extends ColorRect


func _make_custom_tooltip(for_text: String) -> Object:
	var label = Label.new()
	var settings = LabelSettings.new()
	settings.font = load("res://textures/MainFont.ttf")
	label.label_settings = settings
	label.text = for_text
	return label
