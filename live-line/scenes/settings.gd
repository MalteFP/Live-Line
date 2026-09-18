extends Control

var waitingForAction = null

func _ready() -> void:
	Saver.unPackSave()
	$audio.value = Saver.settings["audio"]
	for action in Saver.settings["controls"].keys():
		InputMap.action_erase_event(
			action,
			InputMap.action_get_events(action)[0]
		)

		var ev = eventFromKeycode(Saver.settings["controls"][action])
		InputMap.action_add_event(action, ev)

		$VBoxContainer.get_node(action).get_node("Button").text = ev.as_text()

func _on_back_to_main_menu_button_down() -> void:
	Saver.settings = exportSettings()
	Saver.saveGame()
	get_tree().change_scene_to_file("res://mainMenu.tscn")


func _on_audio_value_changed(value: float) -> void:
	var linear = $audio.value / 100
	var db = linear_to_db(linear)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)


func _on_button_pressed(actionName: String) -> void:
	waitingForAction = actionName
	
func _input(event: InputEvent) -> void:
	$info.visible = true
	if waitingForAction == null or event.as_text() =="Escape":
		waitingForAction = null
		$info.visible = false
		return
	
	if event is InputEventKey and event.is_pressed():
		InputMap.action_erase_event(waitingForAction, InputMap.action_get_events(waitingForAction)[0])
		
		InputMap.action_add_event(waitingForAction, event)
		
		print("New binding for" + str(waitingForAction) + "is" + str(event))
		
		$VBoxContainer.get_node(waitingForAction).get_node("Button").text = str(event.as_text())
	
		waitingForAction = null
		$info.visible = false

func exportSettings() -> Dictionary:
	var dic = {}

	dic["audio"] = $audio.value
	dic["controls"] = {}

	for action in ["up", "down", "right", "left", "attack"]:
		var event = InputMap.action_get_events(action)[0]
		dic["controls"][action] = event.physical_keycode

	print(dic)
	return dic


func eventFromKeycode(keycode: int) -> InputEventKey:
	var ev = InputEventKey.new()
	ev.physical_keycode = keycode
	return ev
