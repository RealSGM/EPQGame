extends Control

onready var container = $TextureRect/Control
onready var noOfChilds = container.get_child_count()
onready var rewardNode = $TextureRect/Control/ItemGet/Icon
export var empty: Texture

signal item_drop_signal
var forgeFinished = true

func _on_SubmitButton_pressed():
	if forgeFinished:
		var slotsFilled = true
		for slot in Global.forge_data.keys():
			if Global.forge_data[slot]["Item"] == null:
				get_node("TextureRect/Control/" + slot + "/AnimationPlayer").play("Empty")
				slotsFilled = false
		if !(Global.rewardID == null):
			$AnimationPlayer.play("ItemBlocked")
		
		if slotsFilled == true:
			if $TextureRect/Control/ItemGet/Icon.texture_normal == null:
				#Plays forging animation
				$AnimationPlayer.play("ForgeArrows")
				yield(get_tree().create_timer(1), "timeout")
				
				#Gets rid of the items in the forge
				var itemId
				var itemName

				if Global.forgingItem == "Shard":
					itemId = int(Global.forge_data["Forge1"]["Item"]) - 1

				elif Global.forgingItem == "Plate":
					itemId = int(Global.forge_data["Forge1"]["Item"])
					itemName = 	GameData.item_data[str(itemId)]["ItemName"]
					var materialName = (itemName.split(" "))[0]
					var chosenList = []
					match materialName:
						"Dull":
							chosenList = GameData.dull_set
						"Butter":
							chosenList = GameData.butter_set
						"Blue":
							chosenList = GameData.blue_set
						"Iron":
							chosenList = GameData.iron_set
						"Reinforced":
							chosenList = GameData.reinforced_set
						"Amethyst":
							chosenList = GameData.amethyst_set
						"Pretty":
							chosenList = GameData.pretty_set
						"Emerald":
							chosenList = GameData.emerald_set
						"Ruby":
							chosenList = GameData.ruby_set
						"Titanium":
							chosenList = GameData.titanium_set
						_:
							chosenList = GameData.cursed_set
					chosenList.shuffle()
					itemId = chosenList[0]
						
					

							
					
				$AnimationPlayer.play("ReturnArrows")		
				for slot in Global.forge_data.keys():
					Global.forge_data[slot]["Item"] = null
					get_node("TextureRect/Control/" + slot + "/Icon").texture_normal = null	
						
				itemName = 	GameData.item_data[str(itemId)]["ItemName"]
				var texturePath = load("res://ITEMS/ItemIcons/" + itemName + ".png")	
				rewardNode.texture_normal = texturePath
						
				Global.rewardID = itemId
				Global.forgeCount = 0
				Global.forgingItem = null
				Global.forgeItem = null
			
			

	
		
func _input(event):
	if event.is_action_pressed("ui_esc") and visible == true:
		remove_items()


func _on_ExitButton_pressed():
	visible = false
	get_node("../Inventory").visible = false
	get_tree().paused = !get_tree().paused
	Global.paused = !Global.paused
	remove_items()

func remove_items():
	#Removes items from forge and drops into world
	for slot in Global.forge_data.keys():
		var slotId = Global.forge_data[slot]["Item"]
		if slotId != null:
			emit_signal("item_drop_signal",slotId)
		var forgeNode = get_node("TextureRect/Control/" + slot + "/Icon")
		forgeNode.texture_normal = null
		Global.forge_data[slot]["Item"] = null
		
	#Removes item from reward slot and drops into world
	if Global.rewardID != null:
		emit_signal("item_drop_signal", Global.rewardID)
		get_node("TextureRect/Control/ItemGet/Icon").texture_normal = null
		
	Global.forgeCount = 0
	Global.forgeItem = null
	Global.forgingItem = null
	Global.rewardID = null


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "ReturnArrows":
		forgeFinished = true


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "ForgeArrows":
		forgeFinished = false
