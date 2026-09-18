extends Node2D

var degreePerSlice = 360/8
enum itemTypes { dmg, enemy, fuse, light, size}
var spinsLeft = 0

var everLeveledUp = false

@onready var objectDic = {
0: get_tree().get_first_node_in_group("player"),
1: $"../..", 
2: get_tree().get_first_node_in_group("player"),
3: get_tree().get_first_node_in_group("player").get_node("AnimatedSprite2D/PointLight2D"),
4: get_tree().get_first_node_in_group("player").get_node("Sword")
}

var propDic = {
0: "damage",
1: "bonusScalingMult",
2: "fuseMult",
3: "texture_scale",
4: "scale"
}

var colorMulti = {
"Red": -1,
"Yellow": 1,
"Green": 1.5,
"DarkGreen": 3
}

var typeMulti = {
0: 1,
1: 0.1,
2: 0.25,
3: 0.25,
4: Vector2(0.25, 0.25)
}

var discDict = {
0: "Increased damage by ",
1: "Increased enemy scaling by ",
2: "Increased fuses collected by ",
3: "Increased light size by ",
4: "Increased sword size by "
}

var wheelArr = []

@onready var p = preload("res://scenes/powerup.tscn")
@onready var powerupObject = p.instantiate()


var colors = ["Yellow", "Green", "Red", "DarkGreen", "Yellow", "Green", "Red", "Green"]
func _ready() -> void:
	add_child(powerupObject)
	buildWheel()

func buildWheel():
	wheelArr = $"..".makeWheelArr()
	var items = $Node2D/wheel.get_children()
	for i in range(items.size()):
		items[i].texture = load("res://textures/sprites/powerUps/" + str(itemTypes.keys()[wheelArr[i]]) + str(colors[i]) + ".png")

func levelUp():
	spinsLeft += 1
	if spinsLeft > 0:
		var tween = get_tree().create_tween()
		tween.tween_property($Node2D,"global_position",Vector2(976,150),2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
		
		await tween.finished
		$Node2D/spin.disabled = false
	
func powerup(slice):
	var type = wheelArr[slice]
	var power = Callable(powerupObject,"apply").bind(
		objectDic[type], 
		propDic[type], 
		colorMulti[colors[slice]] * typeMulti[type],
		false, 
		discDict[type] + str(colorMulti[colors[slice]] * typeMulti[type] * 100) + "%", 
		load("res://textures/sprites/powerUps/" + str(itemTypes.keys()[type]) + colors[slice] + ".png"))
	power.call()
	if not everLeveledUp:
		everLeveledUp = true
		var label = get_tree().get_first_node_in_group("tutorialLabel")
		var settings = LabelSettings.new()
		settings.font_size = 24
		label.label_settings = settings
		label.text = "You have now unlocked the power\nto control your own future"
		$"../Button".visible = true



func _on_spin_button_down() -> void:
	$Node2D/wheel.rotation = 0
	$Node2D/spin.disabled = true
	spinsLeft -= 1
	var spin = randf_range(0, 360)
	var color = floori(spin/degreePerSlice)
	var tween = get_tree().create_tween()
	tween.tween_property($Node2D/wheel, "rotation", deg_to_rad(3600 + spin), 7).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(10).timeout
	powerup(color)
	if spinsLeft > 0:
		$Node2D/spin.disabled = false
		return
	else:
		var tweenBack = get_tree().create_tween()
		tweenBack.tween_property($Node2D, "global_position",Vector2(976,-266.0),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
