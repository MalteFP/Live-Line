extends Node2D
class_name itemSlot


enum itemTypes { dmg, enemy, fuse, light, size}
var permItem: item
var heldItem: item
@export var refill: bool = false
@export var itemType: itemTypes
@export var bin: bool = false
@export var wheelPos: int = -1

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and not event.pressed and not refill:
		get_parent().get_parent().emit_signal("droppedInSlot", self)

func _process(_delta: float):
	resetPosition()

func _ready():
	if refill:
		var scene := preload("res://item.tscn")
		var items := scene.instantiate()
		get_parent().get_parent().add_child.call_deferred(items)
		call_deferred("setItem", items)
		items.setItemType(itemType)
		permItem = items.duplicate()
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
	heldItem.reloadTexture()

func removeItem():
	heldItem = null
	if refill and heldItem == null:
		var newItem = permItem.duplicate()
		newItem.setItemType(itemType)
		get_parent().get_parent().add_child(newItem)
		setItem(newItem)
		
	
func resetPosition():
	if get_parent().get_parent().loading and heldItem:
		heldItem.global_position = global_position
		heldItem.global_rotation = global_rotation
