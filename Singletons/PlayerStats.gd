extends Node


var damage = 1 
var chanceHit = 0
var extraHealth = 0
var extraSpeed = 0
var extraDamageHands = 0
var extraDamageWeapon = 0
var extraMana = 0
var bowDamage = 1
var bowReady = true
var bowDelay = 0.4
var maxMana = 10 
var mana = 10 
var manaRegeneration = 0.2 
var healthRegeneration = 0.2 
var MODIFIER = 1
var swordId
var bowId
var spellId
var potionId
var foodId


onready var maxHealth = 10 
onready var health = maxHealth setget set_health


signal no_health

func _ready():
	randomize()
	PlayerStats.maxHealth = 10 
	PlayerStats.health = 10 

func update_player_stats():
	swordId = PlayerData.equipment_data["Melee"]
	if swordId != null:
		extraDamageWeapon = GameData.item_data[str(swordId)]["ItemDamage"]
	else:
		extraDamageWeapon = 0

	var IdBody = PlayerData.equipment_data["Body"]
	if IdBody != null:
		chanceHit = GameData.item_data[str(IdBody)]["ItemDefense"]
	else:
		chanceHit = 0

	var IdHead = PlayerData.equipment_data["Head"]
	if IdHead != null:
		extraHealth = GameData.item_data[str(IdHead)]["ItemExtraHealth"]
		maxHealth = 10   + extraHealth 
		PlayerStats.maxHealth = maxHealth
	else:
		maxHealth = 10 
	var IdFeet = PlayerData.equipment_data["Feet"]
	if IdFeet != null:
		extraSpeed = GameData.item_data[str(IdFeet)]["ItemBootSpeed"] 
	else:
		extraSpeed = 0

	var IdHands = PlayerData.equipment_data["Hands"]
	if IdHands != null:
		extraDamageHands = GameData.item_data[str(IdHands)]["ItemAttackModifier"] 
	else:
		extraDamageHands = 0
	
	bowId = PlayerData.equipment_data["Ranged"]
	if bowId != null:
		bowDamage = GameData.item_data[str(bowId)]["ItemDamage"] 
	else:
		bowDamage = 0
		
	damage = extraDamageHands + extraDamageWeapon

func _input(event):
	if event.is_action("inv_toggle") or event.is_action("ui_esc"):
		update_player_stats()
		
#	if event.is_action_pressed("test_button"):
#		print("Mana ",mana)
#		print("Health ",health)
#		print("Max Health ",maxHealth)

func set_health(value):
	var ranNum = rand_range(1,100)
	if ranNum >= chanceHit:
		health = value
	else:
		print("DODGED")
		
	if health <= 0:
		emit_signal("no_health")
	print('Player Health: ',health)
		

func _on_Timer_timeout(): 
	bowReady = true


func _on_Regeneration_timeout():
	if health != maxHealth:
		health += healthRegeneration
		if health > maxHealth:
			health = maxHealth
		if get_tree().get_root().has_node("SceneHandling/UI/Interface"):
			get_tree().get_root().get_node("SceneHandling/UI/Interface").update_health()
	if mana != maxMana:
		mana += manaRegeneration
		if mana > maxMana:
			mana = maxMana
		if get_tree().get_root().has_node("SceneHandling/UI/Interface"):	
			get_tree().get_root().get_node("SceneHandling/UI/Interface").update_mana()
