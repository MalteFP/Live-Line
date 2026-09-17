extends Node2D
class_name itemSlot

var heldItem: item
@export var refill: bool = false
@export var bin: bool = false

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and not event.pressed and not refill:
		get_parent().get_parent().emit_signal("droppedInSlot", self)

func _ready():
	if refill:
		var scene := preload("res://item.tscn")
		var item := scene.instantiate()
		get_parent().get_parent().add_child.call_deferred(item)
		call_deferred("setItem", item)
	if bin:
		$Area2D/Sprite2D.texture = load("res://textures/menu/trash.png")
	else:
		$Area2D/Sprite2D.texture = load("res://textures/menu/borader.png")

func setItem(i: item):
	heldItem = i
	i.storedIn = self
	i.global_position = global_position
	i.global_rotation = global_rotation
	if bin:
		heldItem = null

func removeItem():
	heldItem = null
	if refill and heldItem == null:
		var scene := preload("res://item.tscn")
		var item := scene.instantiate()
		get_parent().get_parent().add_child.call_deferred(item)
		call_deferred("setItem", item)
	
