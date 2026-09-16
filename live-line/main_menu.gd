extends Control

var loadID = 0

func _on_quit_button_down() -> void:
	get_tree().quit()


func _on_start_game_button_down() -> void:
	$CanvasLayer/loading.visible = true
	ResourceLoader.load_threaded_request("res://scenes/testWorld.tscn")
	while true:
		var status = ResourceLoader.load_threaded_get_status("res://scenes/testWorld.tscn")
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			var scene = ResourceLoader.load_threaded_get(
				"res://scenes/testWorld.tscn"
			)
			get_tree().change_scene_to_packed(scene)
			break
		await get_tree().process_frame
	
