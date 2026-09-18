extends CanvasLayer

signal droppedInSlot(which: itemSlot)
var loading = false
var isOpen: bool = false
@onready var menu = $menu
@onready var wheel = $"Wheel holder"
func _ready() -> void:
	menu.global_position = Vector2(1152 + 128, 0)
	wheel.global_position = Vector2(-256,324)
	wheel.rotation_degrees = 180
	
	
func open():
	isOpen = true
	loading = true
	var tween = get_tree().create_tween()
	
	tween.tween_property(wheel, "global_position",Vector2(128 * PI,324),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(wheel, "rotation", deg_to_rad(360),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(menu, "global_position", Vector2(1152-128,0),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($levelUpScreen/Node2D, "global_position",Vector2(976,-133),0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	await tween.finished
	if isOpen:
		loading = false


func close():
	isOpen = false
	loading = true
	var tween = get_tree().create_tween()
	
	tween.tween_property(wheel, "global_position",Vector2(-256,324),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(wheel, "rotation", deg_to_rad(180),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(menu, "global_position", Vector2(1152 + 128, 0),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	if $levelUpScreen.spinsLeft > 0:
		tween.parallel().tween_property($levelUpScreen/Node2D, "global_position",Vector2(976,150),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	await tween.finished
	if not isOpen:
		loading = false
	makeWheelArr()



func _on_button_button_down() -> void:
	if isOpen:
		close()
	else:
		open()

func makeWheelArr():
	var arr = []
	var slots = $"Wheel holder".get_children()
	for slot in slots:
		if slot is Sprite2D or slot.wheelPos == -1:
			continue
		if slot.heldItem:
			arr.append(slot.heldItem.itemTypes.keys()[slot.heldItem.itemType])
		else:
			arr.append(null)
	print(arr)
