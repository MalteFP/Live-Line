extends Node2D
class_name itemSlot


enum itemTypes { dmg, enemy, fuse, light, size}
var permItem: item
var heldItem: item
@export var refill: bool = false
@export var itemType: itemTypes
@export var bin: bool = false

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and not event.pressed and not refill:
		get_parent().get_parent().emit_signal("droppedInSlot", self)

func _process(delta: float):
	resetPosition()

func _ready():
	if refill:
		var scene := preload("res://item.tscn")
		var item := scene.instantiate()
		get_parent().get_parent().add_child.call_deferred(item)
		call_deferred("setItem", item)
		item.setItemType(itemType)
		permItem = item.duplicate()
		print(permItem)
	if bin:
		$Area2D/Sprite2D.texture = load("res://textures/menu/trash.png")
	else:
		$Area2D/Sprite2D.texture = load("res://textures/menu/borader.png")

func setItem(i: item):
	if not refill and heldItem:
		heldItem.queue_free()
		heldItem = null
	heldItem = i
	i.storedIn = self
	i.global_position = global_position
	i.global_rotation = global_rotation

func removeItem():
	heldItem = null
	if refill and heldItem == null:
		var newItem = permItem.duplicate()
		get_parent().get_parent().add_child(newItem)
		setItem(newItem)
		print(heldItem)
		
	
func resetPosition():
	if get_parent().get_parent().loading and heldItem:
		heldItem.global_position = global_position
		heldItem.global_rotation = global_rotation
