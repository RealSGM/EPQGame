extends Control

export var templateButton: PackedScene
onready var GC = get_node("ColorRect/GridContainer")
var currentButton 
var firstPress = true

func _ready():
	for attribute in GameData.attributes_data.keys():
		var attriInstance = templateButton.instance()
		var attriName =  GameData.attributes_data[attribute]["AttributeName"]
#		var attriPath = "res://GUI/AttributeIcons/" + attriName + ".png"
		attriInstance.rect_scale = Vector2(0.2,0.2)
		attriInstance.attriId = attribute
		attriInstance.attriName = attriName
#		attriInstance.texture_normal = load(attriPath)
			
		
		if int(attribute) in PlayerData.unlockedAttributes:
			attriInstance.disabled = false
			
			attriInstance.get_node("ColorRect").visible = false
		else:
			attriInstance.disabled = true
#
		GC.add_child(attriInstance)

	
		
	for attribute in GC.get_children():
		attribute.connect("attri_toggled",self,"attri_selected")

func attri_selected(id,path):
	if firstPress == true:
		firstPress = false
		PlayerData.chosenAttribute = id
	else:
		if currentButton == path:
			PlayerData.chosenAttribute = null
		else:
			currentButton.pressed = false
			PlayerData.chosenAttribute = id
		
	currentButton = path
	

