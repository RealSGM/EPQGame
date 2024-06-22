extends ColorRect

onready var CC = $CenterContainer

func _on_Button_pressed():
	get_tree().paused = false
	if Global.prevScene == "res://Scenes/MainMenu.tscn":
		queue_free()
	elif Global.prevScene == "res://Scenes/SceneHandling.tscn":
		visible = false


func _on_Button1_pressed():
	CC.visible = false
