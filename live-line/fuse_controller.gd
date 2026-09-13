extends Node2D

var notLayedWire = 0
var fuseArr = []
var firePos: Vector2
var lastDir := "up"

var initFuseSize = 30

var rotationDic = {"up":180, "down":0, "right": 270, "left": 90}

@onready var label = $CanvasLayer/Label
@onready var fire = $fire

func _process(delta: float) -> void:
	label.text = str(fuseArr.size() + notLayedWire)


func _ready():
	await get_tree().create_timer(0).timeout
	var texture = "res://textures/sprites/Fuse/upup.png"
	for i in range(initFuseSize):
		var fuse = preload("res://fuse.tscn")
		var instance = fuse.instantiate()
		instance.get_node("Sprite2D").texture = load(texture)
		instance.global_position = get_parent().body.global_position + (initFuseSize - i) * Vector2(0,16)
		instance.set_meta("dir","up")
		fuseArr.append(instance)
		add_child(instance)

func playerMoved(direction: String):
	addNewFuse(direction)
	for i in range(2):
		if fuseArr.size() > 0 and notLayedWire == 0:
			
			fire.global_position = fuseArr[0].global_position
			fire.rotation_degrees = rotationDic[fuseArr[0].get_meta("dir")]
			fuseArr.pop_front().queue_free()
			fuseArr.front().visible = false
			fire.play("default")
			fire.visible = true
		elif fuseArr.size() == 0:
			print("BOOM YOU DIED")
		if notLayedWire >= 1:
			notLayedWire -= 1
		else:
			notLayedWire = 0
			
		
			
func addNewFuse(dir: String):
	var texture = "res://textures/sprites/Fuse/" + dir + lastDir + ".png"
	var fuse = preload("res://fuse.tscn")
	var instance = fuse.instantiate()
	instance.global_position = get_parent().body.global_position
	instance.get_node("Sprite2D").texture = load(texture)
	instance.set_meta("dir",dir)
	fuseArr.append(instance)
	add_child(instance)
	lastDir = dir
