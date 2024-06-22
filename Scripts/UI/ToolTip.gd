extends Control

var origin = ""
var slot = ""
var valid = false
var dragPos = null

func _ready():
	hint_tooltip = name
	update_tool_tip()
	

func _input(event):
	if event.is_action("ui_esc") or event.is_action("inv_toggle"):
		queue_free()
		
func update_tool_tip():
	var itemId = ""
	if origin == "Inventory":
		if PlayerData.inv_data[slot]["Item"] != null:
			itemId = str(PlayerData.inv_data[slot]["Item"])
			valid = true
			Global.toolTipLocation = "Inventory"
	
	elif origin == "CharacterSheet":
		if PlayerData.equipment_data[slot] != null:
			itemId = str(PlayerData.equipment_data[slot])
			valid = true
			Global.toolTipLocation = "CharacterSheet"
			Global.toolTipNodeSlot = GameData.item_data[itemId]["NodeSlot"]
			
	elif origin == "Forge":
		if Global.forge_data[slot]["Item"] != null:
			itemId = str(Global.forge_data[slot]["Item"])
			valid = true
			Global.toolTipLocation = "Forge"
			
	elif origin == "ForgeReward":
		if Global.rewardID != null:
			itemId = Global.rewardID
			valid = true
			Global.toolTipLocation = "ForgeReward"
	elif origin == "Shop":
		if Global.shop_data[slot]["Item"] != null:
			itemId = str(Global.shop_data[slot]["Item"])
			valid = true
			Global.toolTipLocation = "Shop"
	
	Global.toolTipSlot = slot		
	
	
	if valid:
		itemId = str(itemId)
		get_node("P/MC/VBC/VBoxContainer/TextureButton/ItemName").set_text(GameData.item_data[itemId]["ItemName"])
		var itemStat = 1
		for i in range(GameData.item_stats.size()):
			var statName = GameData.item_stats[i]
			var statLabel = GameData.item_stat_labels[i]
			if GameData.item_data[itemId][statName] != null:
				var statValue = GameData.item_data[itemId][statName]
				get_node("P/MC/VBC/Stat" + str(itemStat) + "/Stat").set_text(statLabel + ": " + str(statValue))
				itemStat += 1 
	

func _on_ToolTip_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			dragPos = get_global_mouse_position() - rect_global_position
		else:
			dragPos = null
	if event is InputEventMouseMotion and dragPos:
		rect_global_position = get_global_mouse_position() - dragPos

func _on_TextureButton_pressed():
	Global.toolTipEnabled = false
	Global.toolTipSlot = null
	Global.toolTipLocation  = null
	queue_free()
