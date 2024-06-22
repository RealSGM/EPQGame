extends TextureButton

#onready var toolTip = preload("res://Scenes/ToolTip.tscn")
export var toolTip: PackedScene
export var default_outline: Texture

func _ready():
	connect("pressed",self,"create_tool_tip")
	connect("mouse_entered",self,"_on_Icon_mouse_entered")
	connect("mouse_exited",self,"_on_Icon_mouse_exited")


func get_drag_data(_pos):
	var equipmentSlot = get_parent().get_name()
	if PlayerData.equipment_data[equipmentSlot] != null:
		var data = {}
		data["originNode"] = self
		data["originPanel"] = "CharacterSheet"
		data["originItemId"] = PlayerData.equipment_data[equipmentSlot]
		data["originEquipmentSlot"] = equipmentSlot
		data["originTexture"] = texture_normal
		data["originNodeSlot"] = GameData.item_data[str(PlayerData.equipment_data[equipmentSlot])]["NodeSlot"]
			
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
	var targetEquipmentSlot = get_parent().get_name()
	if targetEquipmentSlot == data["originEquipmentSlot"]:
		if PlayerData.equipment_data[targetEquipmentSlot] == null:
			data["targetItemId"] = null
			data["targetTexture"] = null
		else:
			data["targetItemId"] = PlayerData.equipment_data[targetEquipmentSlot]
			data["targetTexture"] = texture_normal
		return true
	else:
		return false
	
func drop_data(_pos, data):
	var targetEqipmentSlot = get_parent().get_name()
	var originSlot = data["originNode"].get_parent().get_name()
	
	#Update data origin
	if data["originPanel"] == "Inventory":
		PlayerData.inv_data[originSlot]["Item"] = data["targetItemId"]
	else:
		PlayerData.equipment_data[originSlot] = data["targetItemId"]
	
	#Update origin texture
	if data["originPanel"] == "CharacterSheet" and data["targetItemId"] == null:
		var default_texture = load("res://GUI/OutlineIcons/Outline.png")
		data["originNode"].texture = default_texture
		
	else:
		data["originNode"].texture_normal = data["targetTexture"]
	
	#Update the target data and texture
	PlayerData.equipment_data[targetEqipmentSlot] = data["originItemId"]
	texture_normal = data["originTexture"]
	
	get_parent().texture = default_outline
	
	get_tree().get_root().get_node("SceneHandling/UI/HotBar").update_hotbar_slots()
	if get_tree().get_root().has_node("SceneHandling/Game/YSort/Player/WeaponController"):
		get_tree().get_root().get_node("SceneHandling/Game/YSort/Player/WeaponController").update_weaponSprites()
	else:
		get_tree().get_root().get_node("SceneHandling/Lobby/Player/WeaponController").update_weaponSprites()
		
		
func create_tool_tip():	
	if Global.toolTipEnabled == false:
		var toolTipInstance = toolTip.instance()
		toolTipInstance.origin = "CharacterSheet"
		toolTipInstance.slot = get_parent().get_name()
		toolTipInstance.rect_position = get_parent().get_global_transform_with_canvas().origin
		
		#Code for boundary check
		if toolTipInstance.rect_position.y + get_parent().get_global_transform_with_canvas().origin.y > 176:
			toolTipInstance.rect_position = toolTipInstance.rect_position - Vector2(0,70)
			
			
		add_child(toolTipInstance)
		yield(get_tree().create_timer(0.1), "timeout")
		if has_node("ToolTip") and get_node("ToolTip").valid:
			get_node("ToolTip").show()
		
		Global.toolTipEnabled = true
		

func _on_Icon_mouse_entered():
	if texture_normal != null:	
		get_parent().self_modulate = Color(1,1,1,0.5)


func _on_Icon_mouse_exited():
	get_parent().self_modulate = Color(1,1,1,1)
