extends TextureRect

var itemId
signal item_sell_signal
	
func can_drop_data(_pos,data):
	if data["originPanel"] == "Shop":
		return false
	else:
		return true
	
func drop_data(_pos, data):
	var originSlot = data["originNode"].get_parent().get_name()
	
	#Update data origin	
	if data["originPanel"] == "Inventory":
		itemId = PlayerData.inv_data[originSlot]["Item"]
		PlayerData.inv_data[originSlot]["Item"] = null

	#Update origin texture
	data["originNode"].texture_normal = null
	
	emit_signal("item_sell_signal",itemId)
	$SellSFX.play()
