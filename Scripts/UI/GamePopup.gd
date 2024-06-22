extends TextureRect

signal continue_game
signal new_game

func _on_ContinueButton_pressed():
	emit_signal("continue_game")


func _on_Delete_pressed():
	#Delete Save Game Data
	pass 
