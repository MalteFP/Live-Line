extends Control

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
	
func death() -> void:
		
	var minutes = str(round_to_dec(int(ScoreHolder.timeSpent/60),0)).split(".")[0]
	var seconds = str(int(ScoreHolder.timeSpent)%60)
	
	
	
	$CanvasLayer.visible = true
	$CanvasLayer/VBoxContainer/Fuse.text = "total fuse: " + str(int(ScoreHolder.totalFuse))
	if !minutes == "0": 
		if seconds.length() == 1:
			seconds = "0" + seconds
		$CanvasLayer/VBoxContainer/Time.text = "total time: " + minutes + " minutes and " + seconds + " seconds"
	else :
		$CanvasLayer/VBoxContainer/Time.text = "total time: " + seconds + " seconds"

