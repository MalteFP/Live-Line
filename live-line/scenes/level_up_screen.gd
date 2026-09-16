extends Node2D

var degreePerSlice = 360/8

@onready var p = preload("res://scenes/powerup.tscn")
@onready var powerupObject = p.instantiate()

@onready var darkGreen = [
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "damage", 5, false, "Increased damaged by 5", load("res://textures/sprites/powerUps/Swordupgrade.png")),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player").get_node("Sword"), "scale", Vector2(1,1), false, "Increased sword size by 1", load("res://textures/sprites/powerUps/Swordupgrade.png")),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "fuseMult", 1.5*get_tree().get_first_node_in_group("player").fuseMult, true, "Increased amount of fuse collected by 1.5x", load("res://icon.svg")),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player").get_node("AnimatedSprite2D/PointLight2D"), "texture_scale", 1, false, "Increased Energy of light by 1", load("res://icon.svg")),
	Callable(powerupObject, "apply").bind($"../..", "bonusScalingMult", -0.15, false, "Decreased all stats of zombies by of light by -15%", load("res://icon.svg"))

]
@onready var green = [
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "damage", 3, false, "Increased damaged by 3", load("res://textures/sprites/powerUps/Swordupgrade.png")),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player").get_node("Sword"), "scale", Vector2(0.5,0.5), false, "Increased sword size by 0.5", load("res://icon.svg")),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "fuseMult", 0.5, false, "Increased amount of fuse collected by +50%", load("res://icon.svg")),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player").get_node("AnimatedSprite2D/PointLight2D"), "texture_scale", 0.5, false, "Increased Energy of light by 0.5", load("res://icon.svg")),
	Callable(powerupObject, "apply").bind($"../..", "bonusScalingMult", -0.1, false, "Decreased all stats of zombies by of light by -10%", load("res://icon.svg"))

	]
@onready var yellow = [
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "damage", 1, false, "Increased damage by 1", load("res://icon.svg")),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player").get_node("Sword"), "scale", Vector2(0.25,0.25), false, "Increased sword size by 0.25", load("res://icon.svg")),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "fuseMult", 0.25, false, "Increased amount of fuse collected by +25%", load("res://icon.svg")),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "fuseMult", 0, false, "Nothing ;)", load("res://icon.svg")),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player").get_node("AnimatedSprite2D/PointLight2D"), "texture_scale", 0.25, false, "Increased Energy of light by 0.25", load("res://icon.svg")),
	Callable(powerupObject, "apply").bind($"../..", "bonusScalingMult", 0.1, false, "Increased all stats of zombies by of light by +10%", load("res://icon.svg"))


	]
@onready var red = [
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "damage", -1, false, "Decreased damage by 1", load("res://icon.svg")),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player").get_node("Sword"), "scale", Vector2(0.1,0.1), false, "Decreased sword size by 0.1", load("res://icon.svg")),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player"), "fuseMult", -0.1, false, "Decreased amount of fuse collected by -10%", load("res://icon.svg")),
	Callable(powerupObject, "apply").bind(get_tree().get_first_node_in_group("player").get_node("AnimatedSprite2D/PointLight2D"), "texture_scale", 0.25, false, "Decreased Energy of light by 0.25", load("res://icon.svg")),
	Callable(powerupObject, "apply").bind($"../..", "bonusScalingMult", $"../..".bonusScalingMult*1.25, true, "Increased all stats of zombies by of light by 1.25", load("res://icon.svg"))


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
