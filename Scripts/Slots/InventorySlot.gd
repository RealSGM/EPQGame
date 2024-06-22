extends TextureButton

#onready var toolTip = preload("res://Scenes/ToolTip.tscn")
export var toolTip: PackedScene


func get_drag_data(_pos):
	var inv_slot = get_parent().get_name()
	if PlayerData.inv_data[inv_slot]["Item"] != null:
		var data = {}
		data["originNode"] = self
		data["originPanel"] = "Inventory"
		data["originItemId"] = PlayerData.inv_data[inv_slot]["Item"]
		data["originEquipmentSlot"] = GameData.item_data[str(PlayerData.inv_data[inv_slot]["Item"])]["ItemSlot"]
		data["originTexture"] = texture_normal
		var dragTexture = TextureRect.new()
		dragTexture.expand = true
		dragTexture.texture = texture_normal
		dragTexture.rect_size = Vector2(16,16)
		
		var control = Control.new()
		control.add_child(dragTexture)
		dragTexture.rect_position = -0.5* dragTexture.rect_size
		set_drag_preview(control)
		return data
	
func can_drop_data(_pos, data):
	var targetInvSlot = get_parent().get_name()
	if PlayerData.inv_data[targetInvSlot]["Item"] == null:
		data["targetItemId"] = null
		data["targetTexture"] = null
		return true

	else:
		data["targetItemId"] = PlayerData.inv_data[targetInvSlot]["Item"]
		data["targetTexture"] = texture_normal		
		
		if data["originPanel"] == "Forge":
			return false

		#Checks if swap between char sheet and backpack works 
		elif data["originPanel"] == "CharacterSheet":
			var targetEquipmentSlot = GameData.item_data[str(PlayerData.inv_data[targetInvSlot]["Item"])]["ItemSlot"]
			if targetEquipmentSlot == data["originEquipmentSlot"]:
				return true
			else:
				return false
		elif data["originPanel"] == "Shop":
			var targetEquipmentSlot = get_parent().get_name()
			if PlayerData.inv_data[targetEquipmentSlot] == null:
				return true
			else:
				return false
		elif data["originPanel"] == "ForgeReward":
			return false
		else:
			return true
	
func drop_data(_pos, data):
	var targetInvSlot = get_parent().get_name()
	var originSlot = data["originNode"].get_parent().get_name()
	
	#Update data origin
	if data["originPanel"] == "Inventory":
		PlayerData.inv_data[originSlot]["Item"] = data["targetItemId"]
		
	elif data["originPanel"] == "CharacterSheet":
		PlayerData.equipment_data[originSlot] = data["targetItemId"]
		get_tree().get_root().get_node("SceneHandling/UI/Control/CharacterSheet").reset_icon(data["originEquipmentSlot"],data["originNodeSlot"])
				
	elif data["originPanel"] == "ForgeReward":
		Global.rewardID = null
		
	elif data["originPanel"] == "Forge":
		Global.forge_data[originSlot]["Item"] = data["targetItemId"]
		Global.forge_data[originSlot]["Item"] = null
		Global.forgeCount -= 1
		if Global.forgeCount == 0:
			Global.forgingItem = null
			Global.forgeItem = null
			
	elif data["originPanel"] == "Shop":
		Global.shop_data[originSlot]["Item"] = data["targetItemId"]
		PlayerData.playerBalance -= data["originValue"]
		get_tree().get_root().get_node("SceneHandling/UI/Control/CoinDisplay").update_coin_count()
		for key in Global.shop_data.keys():
			get_tree().get_root().get_node("SceneHandling/UI/Control/ShopUI/BG/MC/VBoxContainer/GridContainer/" + key + "/Icon").refresh_icon()
	
	#Update origin texture
	if data["originPanel"] == "CharacterSheet" and data["targetItemId"] == null:
		data["originNode"].texture_normal = null
	else:
		data["originNode"].texture_normal = data["targetTexture"]	
		
	
		
		
	#Update target texture and data
	PlayerData.inv_data[targetInvSlot]["Item"] = data["originItemId"]
	texture_normal = data["originTexture"]
	
	get_tree().get_root().get_node("SceneHandling/UI/HotBar").update_hotbar_slots()
	if get_tree().get_root().has_node("SceneHandling/Game/YSort/Player/WeaponController"):
		get_tree().get_root().get_node("SceneHandling/Game/YSort/Player/WeaponController").update_weaponSprites()
	else:
		get_tree().get_root().get_node("SceneHandling/Lobby/Player/WeaponController").update_weaponSprites()
		
func create_tool_tip():
	if Global.toolTipEnabled == false:
		
		var toolTipinstance = toolTip.instance()
		toolTipinstance.origin = "Inventory"
		toolTipinstance.slot = get_parent().get_name()
		toolTipinstance.rect_position = get_parent().get_global_transform_with_canvas().origin

		#Code for boundary check
		if toolTipinstance.rect_position.x + toolTipinstance.rect_size.x > 320:
			toolTipinstance.rect_position = toolTipinstance.rect_position - Vector2(70,0)

		if toolTipinstance.rect_position.y + toolTipinstance.rect_size.y > 176:
			toolTipinstance.rect_position = toolTipinstance.rect_position - Vector2(0,70)
	
		add_child(toolTipinstance)	
		yield(get_tree().create_timer(0.1), "timeout")
		if has_node("ToolTip") and get_node("ToolTip").valid:
			get_node("ToolTip").show()
		
		Global.toolTipEnabled = true

func _on_Icon_pressed():
	create_tool_tip()

func drop_item():
#	var itemId = PlayerData.inv_data[get_parent().get_name()]["Item"]
	PlayerData.inv_data[get_parent().get_name()]["Item"] = null
	texture_normal = null	
	emit_signal("item_drop_signal")



func _on_Icon_mouse_entered():
	if texture_normal != null:	
		get_parent().self_modulate = Color(1,1,1,0.5)


func _on_Icon_mouse_exited():
	get_parent().self_modulate = Color(1,1,1,1)

