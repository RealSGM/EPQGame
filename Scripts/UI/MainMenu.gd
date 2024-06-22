extends ColorRect

export var optionsMenu: PackedScene
export var lobby: PackedScene
export var ui: PackedScene
export var menu: PackedScene
export var player: PackedScene
export var sceneChanger: PackedScene


signal start_game

func _ready():
	Global.currentMusic = "MainMenu"
	Global.currentScene = "MainMenu"


	
func _on_StartGameButton_pressed():
	get_node("../").add_child(ui.instance())
	get_node("../").add_child(menu.instance())
	get_node("../").add_child(lobby.instance())
	get_node("../").add_child(sceneChanger.instance())
	emit_signal("start_game")
	
#func _on_OptionsButton_pressed():
#	Global.prevScene = "res://Scenes/MainMenu.tscn"
#	get_node("../").add_child(optionsMenu.instance())

func _on_ExitButton_pressed():
	get_tree().quit()
