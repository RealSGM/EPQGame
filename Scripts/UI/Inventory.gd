 extends Control


onready var gridcontainer = get_node("TextureRect/GridContainer")

func _ready():
	load_inv_slots()
	
	
func load_inv_slots():	
	for slot in PlayerData.inv_data.keys():
		if PlayerData.inv_data[slot]["Item"] != null:
			var invSlot = gridcontainer.get_node(slot)
			var itemName = GameData.item_data[str(PlayerData.inv_data[slot]["Item"])]["ItemName"]
			var iconTexture = load("res://ITEMS/ItemIcons/" + itemName + ".png")
			invSlot.get_node("Icon").texture_normal = iconTexture
	
	
	PlayerStats.update_player_stats()
	
func clear_inv_slots():
	for key in PlayerData.inv_data.keys():
		PlayerData.inv_data[key]["Item"] = null
	for slot in gridcontainer.get_children():
		slot.get_node("Icon").texture_normal = null
	
