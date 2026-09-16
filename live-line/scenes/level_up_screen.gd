extends Node2D

var degreePerSlice = 360/8

@onready var p = preload("res://scenes/powerup.tscn")
@onready var powerupObject = p.instantiate()

@onready var darkGreen = [
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "damage", 3, false),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player").get_node("Sword"), "scale", Vector2(1,1), false),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "fuseMult", 1.5*get_tree().get_first_node_in_group("player").fuseMult, true)
	]
@onready var green = [
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "damage", 3, false),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player").get_node("Sword"), "scale", Vector2(1,1), false),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "fuseMult", 0.5, false)
	]
@onready var yellow = [
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "damage", 3, false),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player").get_node("Sword"), "scale", Vector2(1,1), false),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "fuseMult", 0.25, false)
	]
@onready var red = [
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "damage", 3, false),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player").get_node("Sword"), "scale", Vector2(1,1), false),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "fuseMult", 0.1, false)
	]
@onready var colors = [yellow, green, red, darkGreen, yellow, green, red, green]
func _ready() -> void:
	add_child(powerupObject)

func levelUp():
	$CanvasLayer/Node2D/wheel.rotation = 0
	var spin = randf_range(0, 360)
	var color = colors[floori(spin/degreePerSlice)]
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/Node2D, "global_position",Vector2(1152/2,-50),1)
	tween.chain().tween_property($CanvasLayer/Node2D/wheel, "rotation", deg_to_rad(3600 + spin), 10).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	powerup(color)
	await get_tree().create_timer(15).timeout
	var tweenBack = get_tree().create_tween()
	tweenBack.tween_property($CanvasLayer/Node2D, "global_position",Vector2(1152/2,-300),1)

func powerup(colorArr):
	var power = colorArr[randi_range(0, colorArr.size() - 1)]
	power.call()
