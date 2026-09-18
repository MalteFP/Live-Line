extends Node2D


var totalFuseCollected = 30
var notLayedWire = 0
var fuseArr = []
var firePos: Vector2
var lastDir := "up"

var initFuseSize = 30

var rotationDic = {"up":180, "down":0, "right": 270, "left": 90}
var offset = {"up":Vector2(0,16),"down":Vector2(0,-16),"right":Vector2(-16,0),"left":Vector2(16,0)}

var fireTween: Tween
signal finished

@onready var label = $CanvasLayer/Label
@onready var fire = $fire


func _ready():
	fire.play("default")
	await get_tree().create_timer(0).timeout
	var texture = "res://textures/sprites/Fuse/upup.png"
	for i in range(initFuseSize):
		var fuse = preload("res://scenes/fuse.tscn")
		var instance = fuse.instantiate()
		instance.get_node("Sprite2D").texture = load(texture)
		instance.global_position = get_parent().body.global_position + (initFuseSize - i) * Vector2(0,16)
		instance.set_meta("dir","up")
		fuseArr.append(instance)
		add_child(instance)
	label.text = str(fuseArr.size() + notLayedWire)
	removeFuse()

func playerMoved(direction: String):
	addNewFuse(direction)
	for i in range(get_tree().get_first_node_in_group("player").level/2 + 2):
		removeFuse()
	label.text = str(fuseArr.size() + notLayedWire)
	emit_signal("finished")
			
func addNewFuse(dir: String):
	var texture = "res://textures/sprites/Fuse/" + dir + lastDir + ".png"
	var fuse =  preload("res://scenes/fuse.tscn")
	var instance = fuse.instantiate()
	instance.global_position = get_parent().body.global_position
	instance.get_node("Sprite2D").texture = load(texture)
	instance.set_meta("dir",dir)
	fuseArr.append(instance)
	add_child(instance)
	lastDir = dir
	
func shortestAngle(from: float, to: float) -> float:
	var diff = fmod((to - from + 180), 360) - 180
	return from + diff

func playerAttacked():
	for i in range(get_tree().get_first_node_in_group("player").level/2 + 1):
		
		removeFuse()
	label.text = str(fuseArr.size() + notLayedWire)

func takeDamage(damage):
	var tweenHue = $"../../CanvasModulate".create_tween().set_parallel(true)
	tweenHue.tween_property($"../../CanvasModulate", "color", Color.RED, 0.3,)
	tweenHue.chain().tween_property($"../../CanvasModulate", "color", Color.BLACK, 0.3)
	
	for i in range(damage):
		removeFuse()
	label.text = str(fuseArr.size() + notLayedWire)

func updateFire():
	var tween = get_tree().create_tween()
	if fireTween and fireTween.is_running():
		fireTween.custom_step(1)
	tween.parallel().tween_property(fire,"global_position", fuseArr[0].global_position + offset[fuseArr[0].get_meta("dir")], 0.1)
	tween.parallel().tween_property(fire,"rotation_degrees", shortestAngle(fire.rotation_degrees, rotationDic[fuseArr[0].get_meta("dir")]), 0.1)
	fireTween = tween
func removeFuse():
	fire.visible = true
	if notLayedWire > 0:
		notLayedWire -= 1
	elif fuseArr.size() > 0:
		fuseArr.pop_front().queue_free()
		if fuseArr.size() > 0:
			fuseArr.front().visible = false
			updateFire()
		else:
			fire.visible = false
			get_parent().explode()
