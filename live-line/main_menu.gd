extends Control

var loadID = 0

func _ready() -> void:
	Saver.loadGame()
	if not Saver.tutorialComplete:
		Saver.tutorialComplete = false
	
	
	if not Saver.settings.has("audio"):
		Saver.settings["audio"] = 50
	$"CanvasLayer/start game/CheckButton".button_pressed = !Saver.tutorialComplete

	
	var achievements = ["trap", "zombieKiller", "runner", "explosive", "dark"]
	for achievement in achievements:
		if not Saver.achievements.has(achievement):
			Saver.achievements[achievement] = false
	Saver.saveGame()
	
	$CanvasLayer/MenuMusic.play()
	var linear = Saver.settings["audio"] / 100
	var db = linear_to_db(linear)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)
	
	if not Saver.settings.has("controls"):
		var actions = ["up", "down", "left", "right", "attack"]
		for action in actions:
			Saver.settings["controls"][action] = InputMap.action_get_events(action)[0]
		
	for action in Saver.settings["controls"].keys():
		InputMap.action_erase_event(
			action,
			InputMap.action_get_events(action)[0]
		)

		var ev = eventFromKeycode(Saver.settings["controls"][action])
		InputMap.action_add_event(action, ev)

func _on_quit_button_down() -> void:
	Saver.saveGame()
	get_tree().quit()


func _on_start_game_button_down() -> void:
	$CanvasLayer/loading.visible = true
	var scene = preload("res://scenes/world.tscn")
	var world = scene.instantiate()
	world.tutorial = $"CanvasLayer/start game/CheckButton".button_pressed
	if $"CanvasLayer/start game/CheckButton".button_pressed == true:
		$"CanvasLayer/start game/CheckButton".button_pressed = false
	get_tree().change_scene_to_node(world)
	
	


func _on_acheivments_pressed() -> void:
	Saver.loadGame()
	get_tree().change_scene_to_file("res://scenes/Achievements.tscn") # Replace with function body.


func _on_settings_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/settings.tscn")


func eventFromKeycode(keycode: int) -> InputEventKey:
	var ev = InputEventKey.new()
	ev.physical_keycode = keycode
	return ev
