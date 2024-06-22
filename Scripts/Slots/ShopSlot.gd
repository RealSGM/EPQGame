extends TextureButton

#onready var toolTip = preload("res://Scenes/ToolTip.tscn")
export var toolTip: PackedScene
export var insuff: Texture
export var suff: Texture
export var default: Texture

func _ready():
	get_tree().get_root().get_node("SceneHandling/UI/Control/ShopUI").connect("refresh_icon",self,"refresh_icon")
	refresh_icon()

func get_drag_data(_pos):
	var shopSlot = get_parent().get_name()
	if Global.shop_data[shopSlot]["Item"] != null:
		var data = {}
		data["originNode"] = self
		data["originPanel"] = "Shop"
		data["originItemId"] = Global.shop_data[shopSlot]["Item"]
		data["originEquipmentSlot"] = GameData.item_data[str(Global.shop_data[shopSlot]["Item"])]["ItemSlot"]
		data["originTexture"] = texture_normal
		data["originValue"] = GameData.item_data[str(Global.shop_data[shopSlot]["Item"])]["ItemValue"]
		
		if PlayerData.playerBalance - data["originValue"] >= 0:		
			var dragTexture = TextureRect.new()
			dragTexture.expand = true
			dragTexture.texture = texture_normal
			dragTexture.rect_size = Vector2(16,16)
			
			var control = Control.new()
			control.add_child(dragTexture)
			dragTexture.rect_position = -0.5* dragTexture.rect_size
			set_drag_preview(control)
			return data
	
func create_tool_tip():
	if Global.toolTipEnabled == false:
		
		var toolTipinstance = toolTip.instance()
		toolTipinstance.origin = "Shop"
		toolTipinstance.slot = get_parent().get_name()
		toolTipinstance.rect_position = get_parent().get_global_transform_with_canvas().origin

		#Code for bounary check
		if toolTipinstance.rect_position.x + toolTipinstance.rect_size.x > 320:
			toolTipinstance.rect_position = toolTipinstance.rect_position - Vector2(62,0)

		if toolTipinstance.rect_position.y + toolTipinstance.rect_size.y > 176:
			toolTipinstance.rect_position = toolTipinstance.rect_position - Vector2(0,62)
	
		add_child(toolTipinstance)	
		yield(get_tree().create_timer(0.1), "timeout")
		if has_node("ToolTip") and get_node("ToolTip").valid:
			get_node("ToolTip").show()
		
		Global.toolTipEnabled = true



func _on_Icon_pressed():
	create_tool_tip()


func _on_Icon_mouse_entered():
	var itemId = 0
	var itemValue = 0
	itemId = str(Global.shop_data[get_parent().get_name()]["Item"])
	if itemId != "Null":
		itemValue = GameData.item_data[itemId]["ItemValue"]
	if texture_normal != null and PlayerData.playerBalance >= itemValue:	
		get_parent().self_modulate = Color(1,1,1,0.5)


func _on_Icon_mouse_exited():
	get_parent().self_modulate = Color(1,1,1,1)
	
func refresh_icon():
	var itemId = str(Global.shop_data[get_parent().get_name()]["Item"])
	if itemId != "Null":
		var itemValue = GameData.item_data[itemId]["ItemValue"]
		if PlayerData.playerBalance >= itemValue:
			get_parent().texture = suff
		else:
			get_parent().texture = insuff
	else:
		get_parent().texture = default
		
		
		
		
		
		
		
		
		
		
		
		
		
