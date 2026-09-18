extends Control

var loadID = 0

func _ready() -> void:
	Saver.loadGame()
	$CanvasLayer/MenuMusic.play()

func _on_quit_button_down() -> void:
	Saver.saveGame()
	get_tree().quit()


func _on_start_game_button_down() -> void:
	
	$CanvasLayer/loading.visible = true
	var scene = preload("res://scenes/world.tscn")
	var world = scene.instantiate()
	world.tutorial = $"CanvasLayer/start game/CheckButton".button_pressed
	get_tree().change_scene_to_node(world)
	
	


func _on_acheivments_pressed() -> void:
	Saver.loadGame()
	get_tree().change_scene_to_file("res://scenes/Achievements.tscn") # Replace with function body.


func _on_settings_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/settings.tscn")
