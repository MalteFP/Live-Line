extends Area2D
class_name item

var discDic = {
	0: "Increases/decreases the\ndamage of the player sword",
	1: "Increases/decreases enemy\nscaling",
	2: "Increases/decreases the amount\nof fuse collected",
	3: "Increases/decreases the size\nof the player light",
	4: "Increases/decreases the size\nof the player sword"
}

var itemType: itemTypes
enum itemTypes {dmg, enemy, fuse, light, size}
var storedIn: itemSlot = null
var isMouseInArea: bool = false
var isAreaPressed: bool = false

func _process(_delta: float) -> void:
	if isAreaPressed:
		position = get_viewport().get_mouse_position()


func _ready():
	get_parent().droppedInSlot.connect(_droppedInArea)
	$tooltip.tooltip_text = discDic[itemType]
	
	
func _on_mouse_entered() -> void:
	isMouseInArea = true


func _on_mouse_exited() -> void:
	isMouseInArea = false



func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if storedIn:
			storedIn.removeItem()
			storedIn = null
		isAreaPressed = true
	elif event is InputEventMouseButton and not event.pressed:
		await get_tree().create_timer(0).timeout
		if storedIn == null:
			print(storedIn)
			queue_free()
		
func _droppedInArea(which: itemSlot):
	if not isAreaPressed:
		return
	if storedIn:
		storedIn.removeItem()
	storedIn = which
	isAreaPressed = false
	which.setItem(self)
	
func reloadTexture():
	$Sprite2D.texture = load("res://textures/sprites/powerUps/noArrow/" + str(itemTypes.keys()[itemType]) + ".png")

func setItemType(type: int):
	itemType = type as itemTypes
	reloadTexture()
