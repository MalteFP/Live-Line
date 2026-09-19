extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/MenuMusic.play()
	$CanvasLayer/Label.text = "High Score: " + str(Saver.highScore)
	
	var achievements = Saver.achievements.keys()
	
	for achievement in achievements:
		if Saver.achievements[achievement]:
			$CanvasLayer/achievements/FlowContainer.get_node(achievement).unlock()
	print("done")



func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://mainMenu.tscn")
