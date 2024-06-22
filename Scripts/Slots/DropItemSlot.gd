extends TextureRect

var itemId
signal item_drop_signal
	
func can_drop_data(_pos,data):
	if data["originPanel"] != "Shop" and data["originPanel"] != "Forge" and data["originPanel"] != "ForgeReward" :
		return true
	else:
		return false
	
func drop_data(_pos, data):
	var originSlot = data["originNode"].get_parent().get_name()
	#Update data origin	
	if data["originPanel"] == "Inventory":
		itemId = PlayerData.inv_data[originSlot]["Item"]
		PlayerData.inv_data[originSlot]["Item"] = null
	elif data["originPanel"] == "CharacterSheet":
		itemId = PlayerData.equipment_data[originSlot]
		PlayerData.equipment_data[originSlot] = null	
	elif data["originPanel"] == "Forge":
		itemId = Global.forge_data[originSlot]["Item"]
		
	#Update origin texture
	if data["originPanel"] == "CharacterSheet":
		data["originNode"].texture_normal = null
	else:
		data["originNode"].texture_normal = null
	
	get_tree().get_root().get_node("SceneHandling/UI/HotBar").update_hotbar_slots()
	if get_tree().get_root().has_node("SceneHandling/Game/YSort/Player/WeaponController"):
		get_tree().get_root().get_node("SceneHandling/Game/YSort/Player/WeaponController").update_weaponSprites()
	else:
		get_tree().get_root().get_node("SceneHandling/Lobby/Player/WeaponController").update_weaponSprites()
	emit_signal("item_drop_signal",itemId)

