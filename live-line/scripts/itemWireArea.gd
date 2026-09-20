extends Node2D
var amount = 10


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		
		var world = get_tree().get_first_node_in_group("world")
		if world.anyFusePickedUp == false:
			world.anyFusePickedUp = true
			var label = get_tree().get_first_node_in_group("tutorialLabel")
			var settings = LabelSettings.new()
			settings.font_size = 20
			label.label_settings = settings
			label.text = "Fuse acts both to extend your doomed life, but also acts as experience collect 25 to level up"
			
		
		body.get_parent().get_node("FuseController").notLayedWire += int(amount * get_tree().get_first_node_in_group("player").fuseMult)
		get_tree().get_first_node_in_group("player").xpTowardsLevel += amount * get_tree().get_first_node_in_group("player").fuseMult
		ScoreHolder.totalFuse += amount
		$ItemPickUp.play()
		hide()
		await $ItemPickUp.finished
		queue_free()
	
