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
	await tween.finished
	if not isOpen:
		loading = false




func _on_button_button_down() -> void:
	if isOpen:
		close()
	else:
		open()
