extends CanvasLayer

func _ready():
	get_tree().paused = true	
	
	if Global.toolTipEnabled:
		match Global.toolTipLocation:
			"Inventory":
				get_node("../UI/Control/Inventory/TextureRect/GridContainer/" + Global.toolTipSlot + "/Icon").get_child(0).queue_free()
			"CharacterSheet":
				get_node("../UI/Control/CharacterSheet/TextureRect/HBoxContainer/" + Global.toolTipNodeSlot + "/" + Global.toolTipSlot + "/item").get_child(0).queue_free()
			"Forge":
				get_node("../UI/Control/ForgeUI/TextureRect/Control/" + Global.toolTipSlot + "/Icon").get_child(0).queue_free()
			"ForgeReward":
				get_node("../UI/Control/ForgeUI/TextureRect/Control/ItemGet/Icon").get_child(0).queue_free()
			"Shop":
				get_node("../UI/Control/ShopUI/BG/MC/VBoxContainer/GridContainer/" + Global.toolTipSlot + "/Icon").get_child(0).queue_free()
	
	Global.toolTipEnabled = false
	Global.toolTipSlot = null
	Global.toolTipLocation  = null			

	
func _on_Yes_pressed():
	PlayerData.export_save_data(PlayerData.currentsave)
	get_tree().quit()


func _on_No_pressed():
	queue_free()
	if !Global.paused:
		get_tree().paused = !get_tree().paused
