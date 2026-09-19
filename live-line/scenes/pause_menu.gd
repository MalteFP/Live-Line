extends CanvasLayer


func _on_continue_pressed() -> void:
	$"..".paused = false
	visible = false


func _on_giveup_pressed() -> void:
	if not Saver.achievements["explosive"]:
		Saver.achievements["explosive"] = true
		Saver.saveGame()
	
	$"..".paused = false
	visible = false
	for i in range($"../FuseController".fuseArr.size()):
		$"../FuseController".takeDamage(1)
		await get_tree().create_timer(0).timeout
		
		
func _on_quit_game_pressed() -> void:
	Saver.saveGame()
	get_tree().quit()
