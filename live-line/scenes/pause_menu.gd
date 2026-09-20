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
	
	var fuse = $"../FuseController".fuseArr.size() + $"../FuseController".notLayedWire
	for i in range(ceil(fuse / 10)):
		$"../FuseController".takeDamage(10)
		await get_tree().create_timer(0).timeout
	$"../FuseController".takeDamage($"../FuseController".fuseArr.size() + $"../FuseController".notLayedWire)
		
func _on_quit_game_pressed() -> void:
	Saver.saveGame()
	get_tree().quit()
