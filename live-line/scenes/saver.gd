extends Node2D

const save_location = "user://Savefile.json"
var highScore = 0
var completedAchievements = []
var contentToSave = {}
var settings
var achievements = {}

func saveGame():
	
	contentToSave["highScore"] = highScore
	contentToSave["settings"] = settings
	contentToSave["achievements"] = achievements
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contentToSave.duplicate())
	file.close()


func loadGame():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		contentToSave = file.get_var()
		file.close()
		unPackSave()


func unPackSave():
	highScore = contentToSave["highScore"]
	settings = contentToSave["settings"]
	achievements = contentToSave["achievements"]
	
	
	for action in settings["controls"].keys():
		InputMap.action_erase_event(
			action,
			InputMap.action_get_events(action)[0]
		)

		var ev = eventFromKeycode(settings["controls"][action])
		InputMap.action_add_event(action, ev)


func deleteSave():
	contentToSave = {"highScore": 0}
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contentToSave.duplicate())
	file.close()
	highScore = 0

func eventFromKeycode(keycode: int) -> InputEventKey:
	var ev = InputEventKey.new()
	ev.physical_keycode = keycode
	return ev
