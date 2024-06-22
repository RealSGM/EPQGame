extends TextureRect

func can_drop_data(_pos, _data):
	return true
	
func drop_data(_pos, data):
	var originSlot = data["originNode"].get_parent().get_name()
	
	#Update data origin
	
	if data["originPanel"] == "Inventory":
		
		PlayerData.inv_data[originSlot]["Item"] = null
	else:
		PlayerData.equipment_data[originSlot] = null
	
	#Update origin texture
	
	if data["originPanel"] == "CharacterSheet":
		data["originNode"].texture_normal = null
	else:
		data["originNode"].texture_normal = null
	
	#Update the target data and texture
	texture = data["originTexture"]
	
	yield(get_tree().create_timer(0.5), "timeout")	
	
	texture = null
	
	

