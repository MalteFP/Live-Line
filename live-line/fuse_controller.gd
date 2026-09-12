extends Node2D

var fusePos = []
var firePos: Vector2
var lastDir := "up"
func playerMoved(direction: String):
	addNewFuse(direction)
	
func addNewFuse(dir: String):
	var texture = "res://textures/sprites/Fuse/" + dir + lastDir + ".png"
	var fuse = preload("res://fuse.tscn")
	var instance = fuse.instantiate()
	instance.global_position = get_parent().body.global_position
	instance.get_node("Sprite2D").texture = load(texture)
	add_child(instance)
	lastDir = dir
	
