extends Node

var playerBalance = 0
var chosenAttribute = null
var unlockedAttributes = []
var timePlayed = 0
var currentsave = ""
var dead = false
var playerNode = null


var equipment_data = {
"Head": null,
"Body": null,
"Hands": null,
"Feet": null,
"Melee": null,
"Ranged": null,
"Spell": null,
"Consumable": null,
"Attribute": null,
"Finger": null
}

var inv_data = {
	"1": {
	  "Item": null
	},
	"2": {
	  "Item": null
	},
	"3": {
	  "Item": null
	},
	"4": {
	  "Item": null
	},
	"5": {
	  "Item": null
	},
	"6": {
	  "Item": null
	},
	"7": {
	  "Item": null
	},
	"8": {
	  "Item": null
	},
	"9": {
	  "Item": null
	},
	"10": {
	  "Item": null
	},
	"11": {
	  "Item": null
	},
	"12": {
	  "Item": null
	},
	"13": {
	  "Item": null
	},
	"14": {
	  "Item": null
	},
	"15": {
	  "Item": null
	},
	"16": {
	  "Item": null
	},
	"17": {
	  "Item": null
	},
	"18": {
	  "Item": null
	},
	"19": {
	  "Item": null
	},
	"20": {
	  "Item": null
	},
	"21": {
	  "Item": null
	},
	"22": {
	  "Item": null
	},
	"23": {
	  "Item": null
	},
	"24": {
	  "Item": null
	},
	"25": {
	  "Item": null
	}
}

func retrieve_save_data(saveName):
	var loadFile = File.new()
	var load_data = {}
	if loadFile.file_exists(str("res://Data/", saveName[-1],"save.dat")):
		var loadError = loadFile.open(str("res://Data/" , saveName[-1] , "save.dat"), File.READ)
		if loadError == OK:
			load_data = loadFile.get_var()
		else:
			print("Load Error Occured!!")
		
		playerBalance = load_data["PlayerBalance"]
		unlockedAttributes = load_data["UnlockedAttributes"]
		equipment_data = load_data["EquipmentData"]
		inv_data = load_data["InventoryData"]
		timePlayed = load_data["TimePlayed"]
		chosenAttribute = null
		Global.shop_data = load_data["ShopItems"]

func export_save_data(saveName):
	var save_data = {}
	if Global.currentScene != "Lobby":
		save_data["PlayerBalance"] = playerBalance
		save_data["UnlockedAttributes"] = unlockedAttributes
		save_data["EquipmentData"] = equipment_data
		save_data["InventoryData"] = inv_data
		save_data["TimePlayed"] = timePlayed
		save_data["ShopItems"] = Global.shop_data
		save_data["Dead"] = PlayerData.dead
		
		var saveFile = File.new()
		var saveError = saveFile.open(str("res://Data/" , saveName[-1] , "save.dat"), File.WRITE)
		if saveError == OK:
			saveFile.store_var(save_data)
			saveFile.close()
		else:
			print("Save Error Occured!")

func clear_data():
	playerBalance = 0
	chosenAttribute = null
	get_tree().get_root().get_node("SceneHandling/UI/Control/Inventory").clear_inv_slots()	
	get_tree().get_root().get_node("SceneHandling/UI/Control/CharacterSheet").clear_equipment_slots()
	
		
		
		
		
		
		
		
		
		
		
