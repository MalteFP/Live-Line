extends Area2D
class_name item


var itemType: itemTypes
enum itemTypes { dmg, enemy, fuse, light, size}
var storedIn: itemSlot = null
var isMouseInArea: bool = false
var isAreaPressed: bool = false

func _process(delta: float) -> void:
	if isAreaPressed:
		position = get_viewport().get_mouse_position()


func _ready():
	input_pickable
	get_parent().droppedInSlot.connect(_droppedInArea)
	
func _on_mouse_entered() -> void:
	isMouseInArea = true


func _on_mouse_exited() -> void:
	isMouseInArea = false



func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		isAreaPressed = true
		
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
	itemType = type
	reloadTexture()
