extends Control

export var default_texture: Texture
#onready var default_texture = load("res://GUI/OutlineIcons/Outline.png")

	
func load_equipment_slots():
	for item in PlayerData.equipment_data.keys():
		if PlayerData.equipment_data[item] != null:
			var itemName = GameData.item_data[str(PlayerData.equipment_data[item])]["ItemName"]
			var iconTexture = load("res://ITEMS/ItemIcons/" + itemName + ".png")
			var itemId = PlayerData.equipment_data[item]
			var nodeSlot = GameData.item_data[str(itemId)]["NodeSlot"]
			var equipSlot = GameData.item_data[str(itemId)]["ItemSlot"]
			var equipslot = get_node("TextureRect/HBoxContainer/"+ nodeSlot + "/" + item)
			
			get_node("TextureRect/HBoxContainer/" + nodeSlot + "/" + equipSlot).texture = default_texture
			equipslot.get_node("item").texture_normal = iconTexture
		
	PlayerStats.update_player_stats()		
	
	
	
func reset_icon(equipSlot,nodeSlot):
	var outline_texture = load("res://GUI/OutlineIcons/" + equipSlot + ".png")
	get_node("TextureRect/HBoxContainer/" + nodeSlot + "/" + equipSlot).texture = outline_texture
	
func clear_equipment_slots():
	for item in PlayerData.equipment_data.keys():
		PlayerData.equipment_data[item] = null
	load_equipment_slots()
	
func clear_single_slot(item,itemId):
	var nodeSlot = GameData.item_data[str(itemId)]["NodeSlot"]
	var equipSlot = get_node("TextureRect/HBoxContainer/"+ nodeSlot + "/" + item)
	var empty_icon = load("res://GUI/OutlineIcons/" + item + ".png")
	equipSlot.get_node("item").texture_normal = null
	equipSlot.texture = empty_icon
