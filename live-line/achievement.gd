extends TextureRect
var unlocked: bool = false
@export var achievementName: String = "something like this" 
@export var achievementImage: Texture2D


func _ready() -> void:
	texture = achievementImage
	lock()
	

func lock():
	unlocked = false
	self_modulate = Color(0.073, 0.073, 0.073, 1.0)
	$Label.text = "???"


func unlock():
	unlocked = true
	self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Label.text = achievementName
