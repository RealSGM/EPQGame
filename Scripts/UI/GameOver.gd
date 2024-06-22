extends CanvasLayer



func _on_MM_pressed():
	get_tree().change_scene("res://Scenes/SceneHandling.tscn")
	Global.pause_game()
	

func _on_Exit_pressed():
	get_tree().quit()
	
