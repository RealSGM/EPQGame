extends TextureButton

#onready var toolTip = preload("res://Scenes/ToolTip.tscn")

export var toolTip: PackedScene


	#Gets the data of the item being dragged
func get_drag_data(_pos):
	var forgeSlot = get_parent().get_name()
	if Global.forge_data[forgeSlot]["Item"] != null:
		var data = {}	
		data["originNode"] = self
		data["originPanel"] = "Forge"
		data["originItemId"] = Global.forge_data[forgeSlot]["Item"]
		data["originEquipmentSlot"] = GameData.item_data[str(Global.forge_data[forgeSlot]["Item"])]["ItemSlot"]
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
	
	#Checks if the item can be dropped into the slot being hovered over
func can_drop_data(_pos, data):
	var targetInvSlot = get_parent().get_name()
	var possible = false
	if Global.forgingItem == null:
		if int(data["originItemId"]) in GameData.plate_list:
			possible = true
		elif int(data["originItemId"]) in GameData.shard_list:
			possible = true
		else:
			possible = false
						
	elif Global.forgingItem == "Plate":
		if int(data["originItemId"]) == Global.forgeItem:
			possible = true
		else:
			possible = false
	elif Global.forgingItem == "Shard":
		if int(data["originItemId"]) == Global.forgeItem:
			possible = true
		else:
			possible = false
	else:
		possible = false
	
	if possible:	
		if Global.forge_data[targetInvSlot]["Item"] == null:
			data["targetItemId"] = null
			data["targetTexture"] = null
			return true
		else:
			data["targetItemId"] = Global.forge_data[targetInvSlot]["Item"]
			data["targetTexture"] = texture_normal	
			return true
	else:
		return false

	
#	if int(data["originItemId"]) >= int(GameData.materials_list[0]):
#		if Global.forge_data[targetInvSlot]["Item"] == null:
#			data["targetItemId"] = null
#			data["targetTexture"] = null
#			return true
#		else:
#			data["targetItemId"] = Global.forge_data[targetInvSlot]["Item"]
#			data["targetTexture"] = texture_normal
#			return true
#	else:
#		return false
		
func drop_data(_pos, data):
	var targetInvSlot = get_parent().get_name()
	var originSlot = data["originNode"].get_parent().get_name()
	

	#Update data origin
	if data["originPanel"] == "Inventory":
		PlayerData.inv_data[originSlot]["Item"] = data["targetItemId"]
		Global.forgeCount += 1
		
	if Global.forgeCount == 1:
		Global.forgeItem = data["originItemId"]
		if Global.forgeItem in GameData.shard_list:
			Global.forgingItem = "Shard"
		elif Global.forgeItem in GameData.plate_list:
			Global.forgingItem = "Plate"
	
	
	#Update origin texture
	if data["originPanel"] == "CharacterSheet" and data["targetItemId"] == null:
		data["originNode"].texture_normal = null
	else:
		data["originNode"].texture_normal = data["targetTexture"]
	
	#Update target texture and data
	Global.forge_data[targetInvSlot]["Item"] = data["originItemId"]
	texture_normal = data["originTexture"]
	

func create_tool_tip():
	if Global.toolTipEnabled == false:
		var toolTipInstance = toolTip.instance()
		toolTipInstance.origin = "Forge"
		toolTipInstance.slot = get_parent().get_name()
		toolTipInstance.rect_position = get_parent().get_global_transform_with_canvas().origin
		add_child(toolTipInstance)
		
		yield(get_tree().create_timer(0.1), "timeout")
		if has_node("ToolTip") and get_node("ToolTip").valid:
			get_node("ToolTip").show()
		
		Global.toolTipEnabled = true

func _on_Icon_pressed():
	create_tool_tip()


func _on_Icon_mouse_entered():
	if texture_normal != null:	
		get_parent().self_modulate = Color(1,1,1,0.5)


func _on_Icon_mouse_exited():
	get_parent().self_modulate = Color(1,1,1,1)
