extends Node2D

const save_location = "user://Savefile.json"
var highScore = 0
var completedAchievements = []
var contentToSave = {}



func saveGame():
	contentToSave = {"highScore": highScore}
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contentToSave.duplicate())
	file.close()


func loadGame():
	print("test")
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		contentToSave = file.get_var()
		file.close()
		unPackSave()


func unPackSave():
	print("highscore:"+str(contentToSave["highScore"]))
	highScore = contentToSave["highScore"]
	


func deleteSave():
	contentToSave = {"highScore": 0}
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contentToSave.duplicate())
	file.close()
	highScore = 0
