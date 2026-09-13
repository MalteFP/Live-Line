extends Node2D

var notLayedWire = 0
var fuseArr = []
var firePos: Vector2
var lastDir := "up"

var initFuseSize = 30

@onready var label = $CanvasLayer/Label

func _process(delta: float) -> void:
	while notLayedWire > 0:
		addNewFuseAtEnd()
		notLayedWire -= 1
	label.text = str(fuseArr.size())


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
	fuseArr.pop_front().queue_free()
	if fuseArr.size() > 0:
		fuseArr.pop_front().queue_free()
	else:
		print("BOOM YOU DIED")
func addNewFuse(dir: String):
	var texture = "res://textures/sprites/Fuse/" + dir + lastDir + ".png"
	var fuse = preload("res://fuse.tscn")
	var instance = fuse.instantiate()
	instance.global_position = get_parent().body.global_position
	instance.get_node("Sprite2D").texture = load(texture)
	instance.set_meta("dir", lastDir)
	fuseArr.append(instance)
	add_child(instance)
	lastDir = dir

func addNewFuseAtEnd():
	var lastFuse = fuseArr.front()
	var dir = lastFuse.get_meta("dir")
	var texture = "res://textures/sprites/Fuse/" + dir + dir + ".png"
	var fuse = preload("res://fuse.tscn")
	var instance = fuse.instantiate()
	instance.get_node("Sprite2D").texture = load(texture)
	instance.set_meta("dir", dir)
	if dir == "up":
		instance.global_position = lastFuse.global_position + Vector2(0,16)
	elif dir == "down":
		instance.global_position = lastFuse.global_position + Vector2(0,-16)
	elif dir == "left":
		instance.global_position = lastFuse.global_position + Vector2(16,0)
	elif dir == "right":
		instance.global_position = lastFuse.global_position + Vector2(-16,0)
	fuseArr.push_front(instance)
	add_child(instance)
