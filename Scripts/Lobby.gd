extends Node2D

func _ready():
#	$AttributesStation/Texture/Area2D.connect("body_entered",self,"station_entered")
	$OpenDoor.visible = false
	$Confirmation/BG.visible = false
	
	Global.paused = false
	get_tree().paused = false
	Global.currentMusic = "Lobby"
	Global.currentScene = "Lobby"
	PlayerStats.mana = PlayerStats.maxMana
	PlayerStats.health = PlayerStats.maxHealth
	var interface = get_node("../UI/Interface")
	interface.update_mana()
	interface.update_health()
	
func _on_Area2D_body_entered(body):
	if body.has_node("PickupArea"):
		Global.pause_game()
		$OpenDoor.visible = true
		$PopUp/GamePanel0.visible = true
		$PopUp/GamePanel1.visible = true
		$PopUp/GamePanel2.visible = true
		
		
func _on_Area2D_body_exited(body):
	if body.has_node("PickupArea"):
		$OpenDoor.visible = false	


func station_entered(body):
	Global.pause_game()
	if body.has_node("PickupArea"):	
		get_parent().get_node("UI/AttributesUI").visible = true


func _on_Yes_pressed():
	var saveName = Global.currentSave
	var dir = Directory.new()
	dir.remove(Global.cardPath[int(saveName[-1])])
	$PopUp.refresh_saves()
	$Confirmation/BG.visible = false


func _on_No_pressed():
	$Confirmation/BG.visible = false
