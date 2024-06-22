extends Control

signal continue_game
signal delete_save

func _ready():
	$PlayControl.visible = false
	PlayerData.retrieve_save_data(get_parent().get_name())
	var balanceLabel = $MC/VB/Balance
	var attriLabel = $MC/VB/AttributesUnlocked
	var timeLabel = $MC/VB/TimePlayed
	balanceLabel.text = balanceLabel.text + str(PlayerData.playerBalance)
	attriLabel.text = attriLabel.text + str(len(PlayerData.unlockedAttributes))
	timeLabel.text = timeLabel.text + str(round(PlayerData.timePlayed)) + " seconds"
	PlayerData.clear_data()


func _on_Play_pressed():
	PlayerData.currentsave = get_parent().get_name()
	emit_signal("continue_game",get_parent().get_name())



func _on_DeleteSave_pressed():
	PlayerData.currentsave = get_parent().get_name()
	emit_signal("delete_save",get_parent().get_name())


func _on_Load_pressed():
	if Global.currentSave != null:
		var panel = get_tree().get_root().get_node("SceneHandling/Lobby/PopUp/" + Global.currentSave + "/ContinueGame")
		panel.get_node("PlayControl").visible = false
		panel.get_node("LoadControl").visible = true
		
		
	PlayerData.retrieve_save_data(get_parent().get_name())
	Global.currentSave = get_parent().get_name()
		
	$PlayControl.visible = true
	$LoadControl.visible = false
