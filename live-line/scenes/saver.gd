extends Node2D

const save_location = "user://Savefile.json"

var completedAchievements = []
var collectableCollected = []
var highScore = 0
var contentToSave = {}



func saveGame():
	contentToSave = {"completedAchivements": completedAchievements, "highScore": highScore}
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
	completedAchievements = contentToSave["completedAchievements"]
	highScore = contentToSave["highScore"]
	


func deleteSave():
	contentToSave = {"completedAchievements": [-1], "highScore": [-1]}
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contentToSave.duplicate())
	file.close()
	completedAchievements = [-1]
	highScore = [-1]
