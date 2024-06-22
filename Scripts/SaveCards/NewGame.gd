extends Control

signal new_game


func _on_NewGame_pressed():
	PlayerData.currentsave = get_parent().get_name()
	emit_signal("new_game",get_parent().get_name())
