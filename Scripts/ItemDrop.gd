extends KinematicBody2D

export(int) var itemId = 10073
var pickUpReady = false

func _ready():
	var ItemName = GameData.item_data[str(itemId)]["ItemName"]
	var texturePath = "res://ITEMS/ItemIcons/" + ItemName + ".png"
	$Sprite.texture = load(texturePath)

func refresh_drop(_itemId):
	var ItemName = GameData.item_data[str(_itemId)]["ItemName"]
	var texturePath = "res://ITEMS/ItemIcons/" + ItemName + ".png"
	$Sprite.texture = load(texturePath)


func _on_Timer_timeout():
	pickUpReady = true
