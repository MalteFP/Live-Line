extends Control

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
	
func death() -> void:
	$CanvasLayer/GameOver.play()
	var minutes = str(round_to_dec(int(ScoreHolder.timeSpent/60),0)).split(".")[0]
	var seconds = str(int(ScoreHolder.timeSpent)%60)
	
	
	$CanvasLayer.visible = true
	$CanvasLayer/VBoxContainer/Fuse.text = "total fuse: " + str(int(ScoreHolder.totalFuse))
	if Saver.highScore == null:
		Saver.highScore = 0
	if ScoreHolder.totalFuse > Saver.highScore:
		Saver.highScore = ScoreHolder.totalFuse
	Saver.saveGame()

	if !minutes == "0": 
		if seconds.length() == 1:
			seconds = "0" + seconds
		$CanvasLayer/VBoxContainer/Time.text = "total time: " + minutes + " minutes and " + seconds + " seconds"
	else :
		$CanvasLayer/VBoxContainer/Time.text = "total time: " + seconds + " seconds"
	





func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://mainMenu.tscn")
