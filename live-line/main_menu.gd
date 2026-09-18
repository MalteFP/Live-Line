extends Control

var loadID = 0

func _ready() -> void:
	Saver.loadGame()

func _on_quit_button_down() -> void:
	Saver.saveGame()
	get_tree().quit()


func _on_start_game_button_down() -> void:
	
	$CanvasLayer/loading.visible = true
	ResourceLoader.load_threaded_request("res://scenes/world.tscn")
	while true:
		var status = ResourceLoader.load_threaded_get_status("res://scenes/world.tscn")
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			var scene = ResourceLoader.load_threaded_get(
				"res://scenes/world.tscn"
			)
			get_tree().change_scene_to_packed(scene)
			break
		await get_tree().process_frame
	


func _on_acheivments_pressed() -> void:
	Saver.loadGame()
	get_tree().change_scene_to_file("res://scenes/Achievements.tscn") # Replace with function body.
