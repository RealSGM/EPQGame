extends Control

onready var defaultSlot = load("res://GUI/OutlineIcons/Outline.png")
onready var selectedSlotPNG = load("res://GUI/OutlineIcons/HotBarOutline.png")
onready var timer = $Timer
onready var bowDelayTimer = $BG/RangedDelayTimer
onready var bowtimer = $"/root/PlayerStats/BowTimer"
onready var foodTimer = $BG/FoodTimer
onready var swordTimer = $BG/MeleeDelayTimer
onready var foodBar = $BG/ConsumableDelayTimer
 
var hotBarSlot = ["Melee","Ranged","Spell","Consumable"]
var entitiesInside = []

func _ready():
	update_hotbar_slots()
	change_outline('Melee')
		
func _input(event):		
#	var check = check_if_mid_animation()
	if Global.currentScene != "Lobby":
		if event.is_action_pressed("slot1") or event.is_action_pressed("slot2") or event.is_action_pressed("slot3") or event.is_action_pressed("slot4"): 
			move_hotbar_up()
			timer.start()
	#		if check == true:
			if event is InputEventKey and event.pressed:
				match event.scancode:
					49: 
						update_info("Melee")
					50: 
						update_info("Ranged")
					51: 
						update_info("Spell")
					52: 
						update_info("Consumable")

func _process(_delta):
	if Global.paused == false:
		bowDelayTimer.value = bowtimer.time_left*100
		foodBar.value = foodTimer.time_left
	
#func update_player():
#	if get_node("../") == get_tree().get_root().get_node("SceneHandling/Lobby"):
#		swordAnimation = get_tree().get_root().get_node("SceneHandling/Lobby/Player/WeaponController/AnimationPlayer")
#
#func check_if_mid_animation():
#	if !get_tree().get_root().has_node("SceneHandling/MainMenu"):
#		if round(swordAnimation.current_animation_position*100) == 95 or swordAnimation.current_animation_position*100 == 0 or round(swordAnimation.current_animation_position*100) == 45:
#			return(true)
#		else:
#			return(false)

func update_info(itemType):	
	change_outline(itemType)
	Global.equippedSlot = itemType
		

func change_outline(selectedOutline):
	var selectSlotInstance = TextureRect.new()
	selectSlotInstance.rect_size = Vector2(18,18)
	selectSlotInstance.texture = selectedSlotPNG
	for slot in hotBarSlot:	
#		get_node("BG/GridContainer/" + slot).texture = load("res://GUI/OutlineIcons/" + slot + "Outline.png")
		for childNode in get_node("BG/GridContainer/" + slot).get_children():
			childNode.queue_free()
	get_node("BG/GridContainer/" + selectedOutline).add_child(selectSlotInstance)		
	update_hotbar_slots()		
		

func update_hotbar_slots():
	for slot in hotBarSlot:
		if PlayerData.equipment_data[slot] != null:
			get_node("BG/GridContainer/" + slot).texture = defaultSlot
			for childNode in get_node("BG/GridContainer/" + slot).get_children():
				if childNode.rect_size == Vector2(16,16):
					childNode.queue_free()
					
			var slotId = PlayerData.equipment_data[slot]
			var slotName = GameData.item_data[str(slotId)]["ItemName"]
			var slotPath = load("res://ITEMS/ItemIcons/" + slotName + ".png")
			var iconInstance = TextureRect.new()
			iconInstance.rect_size = Vector2(16,16)
			iconInstance.rect_position = Vector2(1,1)
			iconInstance.texture = slotPath
			get_node("BG/GridContainer/" + slot).call_deferred("add_child",iconInstance)
		else:
			get_node("BG/GridContainer/" + slot).texture = load("res://GUI/OutlineIcons/" + slot + ".png")		
			for childNode in get_node("BG/GridContainer/" + slot).get_children():
				if childNode.rect_size == Vector2(16,16):
					childNode.queue_free()



func move_hotbar_down():
	if rect_position == Vector2(0,141):
		$AnimationPlayer.play("MoveDown")

func move_hotbar_up():
	if rect_position == Vector2(0,176):
		$AnimationPlayer.play("MoveUp")	

func _on_Timer_timeout():
	move_hotbar_down()


func _on_Control_mouse_entered():
	modulate = Color(1,1,1,0.1)

func _on_Control_mouse_exited():
	modulate = Color(1,1,1,0.9)

func food_consumed(itemId):
	update_hotbar_slots()
	var waitTime = GameData.item_data[str(itemId)]["ItemEatingTime"]
	foodTimer.set_wait_time(waitTime)
	foodBar.max_value = waitTime
	foodBar.value = waitTime
	foodTimer.start()
	
func _on_FoodTimer_timeout():
	Global.foodTimeOut = true



#func _on_Area2D_body_entered(body):
#	if body.get_name() == "Player" or body is KinematicBody2D:
#		modulate = Color(1,1,1,0.1)
#		entitiesInside.append(body)
#
#func _on_Area2D_body_exited(body):
#	if body.get_name() == "Player" or body is KinematicBody2D:
#		entitiesInside.erase(body)
#	if entitiesInside == []:
#		modulate = Color(1,1,1,1)
