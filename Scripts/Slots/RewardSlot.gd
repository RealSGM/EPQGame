extends TextureButton

#onready var toolTip = preload("res://Scenes/ToolTip.tscn")
export var toolTip: PackedScene

func get_drag_data(_pos):
	var _slot = get_parent().get_name()
	if texture_normal != null:
		var data = {}
		data["originNode"] = self
		data["originPanel"] = "ForgeReward"
		data["originItemId"] = Global.rewardID
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
		
	
func create_tool_tip():
	if Global.toolTipEnabled == false:
		var toolTipInstance = toolTip.instance()
		toolTipInstance.origin = "ForgeReward"
		toolTipInstance.slot = get_parent().get_name()
		toolTipInstance.rect_position = get_parent().get_global_transform_with_canvas().origin
		add_child(toolTipInstance)
		
		yield(get_tree().create_timer(0.1), "timeout")
		if has_node("ToolTip") and get_node("ToolTip").valid:
			get_node("ToolTip").show()
		Global.toolTipEnabled = true
		

func _on_Icon_pressed():
	create_tool_tip()
