extends Control

#var shopSlotTemplate = preload("res://Scenes/Slots/ShopSlot.tscn")
export var shopSlotTemplate: PackedScene

signal refresh_icon

onready var gridContainer = $BG/MC/VBoxContainer/GridContainer

func _ready():
	$BG/FG/SellArea/SellArea/SellSFX.volume_db = -10


func refresh_store():
	if !has_node("BG/MC/VBoxContainer/GridContainer/Shop1"):
		for slot in Global.shop_data.keys():
			var iconTexture 
			if Global.shop_data[slot]["Item"] != null:	
				var itemName = GameData.item_data[str(Global.shop_data[slot]["Item"])]["ItemName"]
				iconTexture = load("res://ITEMS/ItemIcons/" + itemName + ".png")
			
			var shopSlotInstance = shopSlotTemplate.instance()
			shopSlotInstance.get_node("Icon").texture_normal = iconTexture	
			gridContainer.add_child(shopSlotInstance, true)					
	emit_signal("refresh_icon")
