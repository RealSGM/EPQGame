extends Node

export var game: PackedScene
export var itemDrop: PackedScene
export var quitConfirm: PackedScene
export var sceneChanger : PackedScene


var bin 
var pause 
var charSheet
var inv 
var options
var pickUpArea
var shop
var forge 
var attriUI
var hotbar
var interface 
var coindisplay


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if Global.currentScene == "Lobby" or Global.currentScene == "Game":
			if !has_node("QuitConfirmation") and pause.visible == false:
				if has_node("UI/GameOver") and get_node("UI/GameOver/BG").visible == false:
					var quitInstance = quitConfirm.instance()	
					call_deferred("add_child",quitInstance)

func _ready():
	get_tree().set_auto_accept_quit(false)
	$MainMenu.connect("start_game",self,"begin_game")
	Global.paused = false
	get_tree().paused = false

func _input(event):	
	check_ui_exit(event)

	#Checks for anything needed during testing
	if event.is_action_pressed("test_button"):
#		print("Global Pause: ", Global.paused)
		print("Boss?: ", Global.currentMusic)
#		$Game/YSort/Player.global_position += Vector2(64,0)
	if event.is_action_pressed("up"):
		PlayerData.playerNode.global_position += Vector2(0,-64)
	if event.is_action_pressed("down"):
		PlayerData.playerNode.global_position += Vector2(0,64)	
	if event.is_action_pressed("left"):
		PlayerData.playerNode.global_position += Vector2(-64,0)
	if event.is_action_pressed("right"):
		PlayerData.playerNode.global_position += Vector2(64,0)
func check_ui_exit(event):
	#Check if toggling UI is accepted
	if has_node("Menu/OptionsMenu") == true and  options.visible == false and Global.sceneTransitioned == true:
		if (has_node("UI/GameOver") and get_node("UI/GameOver/BG").visible == false) or has_node("Lobby"):
			if event.is_action_pressed("ui_esc"):
				Global.toolTipEnabled = false
				get_tree().paused = !get_tree().paused
				
				#QuitConfirm has highest priority as it is on the closes CL to the User
				if has_node("QuitConfirmation"):
					$QuitConfirmation.queue_free()
					if Global.paused:
						get_tree().paused = !get_tree().paused
				#If the inventory is visible, that means pause menu can't be enabled, closes down most UI		
				elif inv.visible == true:
					shop.visible = false
					forge.visible = false
					inv.visible = false
					bin.visible = false
					coindisplay.visible = false
					charSheet.visible = false
					Global.paused = !Global.paused
				#Disables Attributes UI if that is enabled	
				elif attriUI.visible == true:
					attriUI.visible = false
								
				#Closes down the Game Panels, will not interfere with other UI	
				elif has_node("Lobby") and get_node("Lobby/PopUp/GamePanel0").visible == true:
					get_node("Lobby/PopUp/GamePanel0").visible = false
					get_node("Lobby/PopUp/GamePanel1").visible = false
					get_node("Lobby/PopUp/GamePanel2").visible = false
					get_node("Lobby/Confirmation/BG").visible = false
					Global.paused = !Global.paused
				#If there is nothing visible, only then will the pause menu be visible
				else:
					pause.visible = !pause.visible	
					Global.paused = !Global.paused
				
			#If the inventory is toggle, it will only work if certain UI is not visible
			if event.is_action_pressed("inv_toggle") :
				if pause.visible == false and forge.visible == false and shop.visible == false and Global.currentScene == "Game":
					Global.pause_game()
					bin.visible = !bin.visible
					charSheet.visible = !charSheet.visible
					inv.visible = !inv.visible
					coindisplay.visible = !coindisplay.visible
					for slot in $UI/Control/Inventory/TextureRect/GridContainer.get_children():
						for childNode in slot.get_children():
							if childNode != slot.get_node("Icon"):
								childNode.queue_free()

func optionsButton():
	Global.prevScene = "res://Scenes/SceneHandling.tscn"
	options.visible = true

func _on_SceneChanger_transitioned():
	
	if has_node("Lobby"):
		$Lobby.queue_free()
	
	else:
		$Game.queue_free()
	yield(get_tree().create_timer(0.01), "timeout")
#	Fix later with toosh
	var gameInstance = game.instance()
	add_child(gameInstance,true)
	
	
	
	$Game/YSort/Player.connect("game_over",self,"game_over")
	$Game/YSort/Player/PickupArea.connect("item_found",self,"pick_up") 
	$SceneChanger/AnimationPlayer.play("fade_to_normal")
	$Game/YSort/Player.connect("reduce_mana",get_node("UI/Interface"),"update_mana")
	$Game/YSort/Player.connect("reduce_health",get_node("UI/Interface"),"update_health")
	



func pick_up(items_in_range):
	for item in items_in_range:
		var gridContainer = $UI/Control/Inventory/TextureRect/GridContainer
		for slot in PlayerData.inv_data.keys():
			if PlayerData.inv_data[slot]["Item"] == null:
				if item.pickUpReady == true:
					PlayerData.inv_data[slot]["Item"] = item.itemId
					gridContainer.get_node(slot).get_node("Icon").texture_normal = item.get_node("Sprite").texture
					item.queue_free()
					Global.items_in_range.erase(item)
					yield(get_tree().create_timer(0.5), "timeout")	
					break
			
func drop_item(itemId):
	var itemDropInstance = itemDrop.instance()
	itemDropInstance.itemId = itemId
	
	if Global.currentScene == "Lobby":
		itemDropInstance.position = $Lobby/Player.get_position()
		$Lobby.add_child(itemDropInstance)
	elif Global.currentScene == "Game":
		itemDropInstance.position = $Game/YSort/Player.get_position()
		$Game.add_child(itemDropInstance)
	itemDropInstance.get_node("Timer").set_wait_time(2)	
	itemDropInstance.get_node("Timer").start()
	

func sell_item(itemId):
	var itemValue = GameData.item_data[str(itemId)]["ItemValue"]
	PlayerData.playerBalance += (int(itemValue)+1) / 2
	$UI/Control/CoinDisplay.update_coin_count()
	for key in Global.shop_data.keys():
		get_tree().get_root().get_node("SceneHandling/UI/Control/ShopUI/BG/MC/VBoxContainer/GridContainer/" + key + "/Icon").refresh_icon()

func game_over():
	interface.visible = false
	hotbar.visible = false
	$UI/GameOver/BG.visible = true
	$UI/GameOver/AnimationPlayer.connect("animation_finished",self,"fade_transitioned")
	$UI/GameOver/AnimationPlayer.play("game_over")
#	PlayerData.clear_data()
	PlayerData.dead = true
	PlayerData.export_save_data(Global.currentSave)
	Global.pause_game()
	

func fade_transitioned(anim_name):
	if anim_name == "game_over":
		$UI/GameOver/BG/MC.visible = true
	
		

func begin_game():
	$MainMenu.queue_free()
	forge = $UI/Control/ForgeUI
	bin = $UI/Control/Bin
	coindisplay = $UI/Control/CoinDisplay
	pause = $Menu/PauseMenu
	charSheet = $UI/Control/CharacterSheet
	inv = $UI/Control/Inventory
	options = $Menu/OptionsMenu
	shop = $UI/Control/ShopUI
	attriUI = $UI/AttributesUI
	hotbar = $UI/HotBar
	interface = $UI/Interface
	
	
	$UI/GameOver/BG.visible = false
	$UI/GameOver/BG/MC.visible = false
	attriUI.visible = false
	shop.visible = false
	forge.visible = false
	bin.visible = false
	pause.visible = false
	charSheet.visible = false
	inv.visible = false
	options.visible = false
	coindisplay.visible = false
	$SceneChanger/Black.visible = false
	
#	pause.connect("options_signal",self,"optionsButton")
	$SceneChanger.connect("transitioned",self,"_on_SceneChanger_transitioned")
	$Lobby/Player/PickupArea.connect("item_found",self,"pick_up")
	$UI/Control/DropArea/DropArea.connect("item_drop_signal",self,"drop_item")
	$UI/Control/ForgeUI.connect("item_drop_signal",self,"drop_item")
	$UI/Control/ShopUI/BG/FG/SellArea/SellArea.connect("item_sell_signal",self,"sell_item")
	
func enter_game(saveName):
	Global.currentSave = saveName
	Global.sceneTransitioned = false
	$SceneChanger/Black.visible = true	
	$SceneChanger.transition()
	$UI/HotBar.update_hotbar_slots()
	$UI/Control/CharacterSheet.load_equipment_slots()
	$UI/Control/Inventory.load_inv_slots()
	$UI/Control/CoinDisplay.update_coin_count()
	Global.pause_game()
	PlayerData.playerBalance = 400
	PlayerData.equipment_data["Ranged"] = 10076
	
	
func continue_game(saveName):
	enter_game(saveName)
	
	if PlayerData.dead == false:
		Global.newLevel = false
	else:
		Global.newLevel = true
	
func new_game(saveName):
	PlayerData.clear_data()
	PlayerData.timePlayed = 0
	PlayerData.unlockedAttributes = []
	PlayerData.equipment_data["Melee"] = 10001
	PlayerData.equipment_data["Ranged"] = 10068
	
	PlayerData.dead = false
	Global.newLevel = true	

	enter_game(saveName)

func delete_save(saveName):
	Global.currentSave = saveName
	$Lobby/Confirmation/BG.visible = true
	

func enter_portal():
	PlayerStats.MODIFIER += 0.1
	Global.currentMusic = null
	#Play woooooooooooooooooooooosh sfx!!
	Global.newLevel = true
	var sceneChangeInstance = sceneChanger.instance()
	add_child(sceneChangeInstance,true)
	sceneChangeInstance.get_node("AnimationPlayer").play("fade_to_black")
	sceneChangeInstance.connect("transitioned",self,"_on_SceneChanger_transitioned")
	

	
