extends Control

#signal options_signal
	
func _on_QOTMMButton_pressed():
	PlayerData.export_save_data(PlayerData.currentsave)
	
	PlayerData.clear_data()
	Global.reset_shop()
	Global.currentSave = null
	Global.paused = !Global.paused
	
	get_tree().paused = !get_tree().paused
	get_tree().change_scene("res://Scenes/SceneHandling.tscn")
	
func _on_SGButton_pressed():
	Global.paused = !Global.paused
	PlayerData.export_save_data(PlayerData.currentsave)

#func _on_OptionsButton_pressed():
#	visible = false
#	emit_signal("options_signal")
	


