extends Node

onready var prevScene = "res://Scenes/MainMenu.tscn"
onready var music = get_tree().get_root().get_node("SceneHandling/MusicNCounter")

var cardPath = ["res://Data/0save.dat","res://Data/1save.dat","res://Data/2save.dat"]
var currentSave = null #This should be the name of the GamePanel 



var forgeItem = null
var rewardID = null
var forgingItem = null
var forgeCount = 0
var rewardList = [] 

var equippedSlot = "Melee"
var foodTimeOut = true

var items_in_range = []

var currentMusic = ""
var currentScene = ""

var newLevel = false
var sceneTransitioned = true
var paused = false

var toolTipEnabled = false
var toolTipSlot = null
var toolTipLocation  = null
var toolTipNodeSlot = null

var forge_data = {
	"Forge1": {
	  "Item": null
	},
	"Forge2": {
	  "Item": null
	},
	"Forge3": {
	  "Item": null
	},
	"Forge4": {
	  "Item": null}
}

var shop_data = {
	
	"Shop1": {
	  "Item": null
	},
	"Shop2": {
	  "Item": null
	},
	"Shop3": {
	  "Item": null
	},
	"Shop4": {
	  "Item": null
	},
	"Shop5": {
	  "Item": null
	},
	"Shop6": {
	  "Item": null
	},
	"Shop7": {
	  "Item": null
	},
	"Shop8": {
	  "Item": null}	
	
}
func reset_shop():
	for key in shop_data.keys():
		shop_data[key]["Item"] = null
		

func pause_game():
	paused = !paused
	get_tree().paused = !get_tree().paused
	for sfx in get_tree().get_nodes_in_group("sfx"):
		if !"Music" in sfx.get_name(): 
			sfx.stop()
		


#var keyBindsPath = "res://Data/keybinds.ini"
#var configfile
#var keyBinds = {}
#
#func _ready():
#	configfile = ConfigFile.new()
#	if configfile.load(keyBindsPath) == OK:
#		for key in configfile.get_section_keys("keybinds"):
#			var key_value = configfile.get_value("keybinds",key)
#			print(key," : ", OS.get_scancode_string(key_value))
#			keyBinds[key] = key_value
#	else:
#		print("Config File Not Found")
#		get_tree().quit()
#
#	set_game_binds()
#
#func set_game_binds():
#	for key in keyBinds.keys():
#		var value = keyBinds[key]
#
#		var actionList = InputMap.get_action_list(key)
#		if !actionList.empty():
#			InputMap.action_erase_event(key,actionList[0])
#
#		var newKey = InputEventKey.new()
#		newKey.set_scancode(value)
#		InputMap.action_add_event(key,newKey)




