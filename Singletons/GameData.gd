extends Node

var item_data = {}
var item_stats = ["ItemEatingTime","ItemFoodRegen","ItemDamage","ItemRarity","ItemDefense","ItemAttackModifier","ItemExtraHealth","ItemBootSpeed","ItemMaxHealthGain","ItemManaGain","ItemValue","ItemDescription"]
var item_stat_labels = ["Eat Time","Satiation","Damage","Rarity","Defense","Attack Modifier","Health Boost","Boot Speed","Health Gain","Mana Gain","Value","Desc"] 

var attributes_data = {}

var plate_list = []
var shard_list = []

var dull_set = []
var butter_set = []
var blue_set = []
var iron_set = []
var reinforced_set = []
var emerald_set = []
var pretty_set = []
var amethyst_set = []
var ruby_set = []
var titanium_set = []
var cursed_set = []

var weapon_list = []
var armour_list = []
var consumables_list = []
var extra_list = []
var materials_list = []
var pickaxe_list = []


var all_list = [weapon_list,armour_list,consumables_list,extra_list]

func _ready():
	#Load attributes table
	var attri_data_file = File.new()
	attri_data_file.open("res://Data/AttributesTable.json",File.READ)
	var atri_data_json = JSON.parse(attri_data_file.get_as_text())
	attri_data_file.close()
	attributes_data = atri_data_json.result
	
	#Loads item table
	var item_data_file = File.new()
	item_data_file.open("res://Data/ItemTable.json",File.READ)
	var item_data_json = JSON.parse(item_data_file.get_as_text())
	item_data_file.close()
	item_data = item_data_json.result
	
	for item in item_data.keys(): #Retrieves item data stats
		var itemSlot = item_data[item]["ItemSlot"]
		var itemRarity = item_data[item]["ItemRarity"]
		var itemName = item_data[item]["ItemName"]
		
		if "Pickaxe" in itemName or "Mattock" in itemName or "Double Hoe" in itemName: 
			pickaxe_list.append(item)
		
		itemName = (itemName.split(" "))[0]
		
		match itemSlot: #Puts the different types of items together
			"Plate":
				plate_list.append(int(item))
			"Shard":
				shard_list.append(int(item))
			"Melee":
				weapon_list.append(int(item))
			"Ranged":
				weapon_list.append(int(item))
			"Head":
				armour_list.append(int(item))
			"Body":
				armour_list.append(int(item))
			"Feet":
				armour_list.append(int(item))
			"Hands":
				armour_list.append(int(item))
			"Consumable":
				consumables_list.append(int(item))
			"Material":
				materials_list.append(int(item))
			_:
				extra_list.append(int(item))
		
		if itemRarity == "Cursed":
			cursed_set.append(int(item))
		
		match itemName: #Puts the different sets together
			"Dull":
				dull_set.append(int(item))	
			"Butter":
				butter_set.append(int(item))
			"Blue":
				blue_set.append(int(item))
			"Iron":
				iron_set.append(int(item))
			"Reinforced":
				reinforced_set.append(int(item))
			"Emerald":
				emerald_set.append(int(item))
			"Pretty":
				pretty_set.append(int(item))
			"Amethyst":
				amethyst_set.append(int(item))
			"Ruby":
				ruby_set.append(int(item))
			"Titanium":
				titanium_set.append(int(item))

			
	consumables_list.erase(10143) #Pigs Head, should only be dropped by the boss

				
			
				
