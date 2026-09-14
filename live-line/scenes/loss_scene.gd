extends Control

func death() -> void:
	$CanvasLayer.visible = true
	$CanvasLayer/VBoxContainer/Fuse.text = "total fuse: " + str(ScoreHolder.totalFuse)
	$CanvasLayer/VBoxContainer/Time.text = "total time: " + str(ScoreHolder.timeSpent)
	$CanvasLayer/VBoxContainer/Score.text = "Score: " + str((ScoreHolder.totalFuse / ScoreHolder.timeSpent) * 1000)
