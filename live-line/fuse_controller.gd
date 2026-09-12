extends Node2D

var notLayedWire = 0
var fuseArr = []
var firePos: Vector2
var lastDir := "up"

var initFuseSize = 30

func _ready():
	await get_tree().create_timer(0).timeout
	var texture = "res://textures/sprites/Fuse/upup.png"
	for i in range(initFuseSize):
		var fuse = preload("res://fuse.tscn")
		var instance = fuse.instantiate()
		instance.get_node("Sprite2D").texture = load(texture)
		instance.global_position = get_parent().body.global_position + (initFuseSize - i) * Vector2(0,16)
		fuseArr.append(instance)
		add_child(instance)

func playerMoved(direction: String):
	addNewFuse(direction)
	for i in range(2):
		if fuseArr.size() >= 1 and notLayedWire == 0:
			fuseArr.pop_front().queue_free()
		else:
			notLayedWire -= 1
	
func addNewFuse(dir: String):
	var texture = "res://textures/sprites/Fuse/" + dir + lastDir + ".png"
	var fuse = preload("res://fuse.tscn")
	var instance = fuse.instantiate()
	instance.global_position = get_parent().body.global_position
	instance.get_node("Sprite2D").texture = load(texture)
	fuseArr.append(instance)
	add_child(instance)
	lastDir = dir
