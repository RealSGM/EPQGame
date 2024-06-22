extends Node2D

var mousePos = get_global_mouse_position()

onready var animationPlayer = $AnimationPlayer
onready var bowSprite = $BowSprite
onready var swordSprite = $SwordSprite
onready var staffSprite = $StaffSprite
onready var swordHitBox = $HitBox
onready var consumableSprite =$ConsumableSprite

var mousePosToPlayer = null
var aniIfPlaying = ""


func _ready():
	swordHitBox.knockbackVector = Vector2.ZERO
	swordHitBox.rotation = 0
	swordSprite.rotation = 0
	update_weaponSprites()

func _process(_delta):
	staffSprite.visible = false
	swordSprite.visible = false
	bowSprite.visible = false
	consumableSprite.visible = false
	
	match Global.equippedSlot:
		"Melee":
			rotation = 0
			swordSprite.visible = true
			mousePosToPlayer = get_angle_to(get_global_mouse_position())
			mousePosToPlayer = pow(mousePosToPlayer, 2)
			aniIfPlaying = animationPlayer.get_current_animation()
			if mousePosToPlayer > 2:
				if swordSprite.flip_h == false and aniIfPlaying == "":
					swordSprite.flip_h = true
					swordSprite.offset.x = -14.7
			else:
				if swordSprite.flip_h == true and aniIfPlaying == "":
					swordSprite.flip_h = false
					swordSprite.offset.x = 3.7
		
		"Ranged":
			bowSprite.visible = true
			mousePos = get_local_mouse_position()
			rotation += mousePos.angle() 
			
		"Spell":
			rotation = 0
			staffSprite.visible = true
			mousePosToPlayer = get_angle_to(get_global_mouse_position())
			mousePosToPlayer = pow(mousePosToPlayer, 2)
			if mousePosToPlayer > 2 :
				staffSprite.offset.x = -3
				staffSprite.offset.y = -3

			else:
				staffSprite.offset.x = 7
				staffSprite.offset.y = 4
		"Consumable":
			rotation = 0
			consumableSprite.scale = Vector2(0.5,0.5)
			consumableSprite.visible = true
			mousePosToPlayer = get_angle_to(get_global_mouse_position())
			mousePosToPlayer = pow(mousePosToPlayer, 2)
			
			if mousePosToPlayer > 2 :
				consumableSprite.flip_h = true
				consumableSprite.offset.x = -7
				consumableSprite.offset.y = 3
			else:
				consumableSprite.flip_h = false
				consumableSprite.offset.x = 12
				consumableSprite.offset.y = 3


func _on_Player_arrow_sent():
	animationPlayer.play("ArrowSent")


func _on_Player_melee_attack(): 
	$HitBox/CollisionShape2D.disabled = false
	if swordSprite.flip_h == true:
		animationPlayer.play("SwordAttackLeft")
	else:
		animationPlayer.play("SwordAttackRight")
 yield(get_tree().create_timer(0.3), "timeout")
	

func update_weaponSprites():
	var swordId = PlayerData.equipment_data["Melee"]
	var bowId = PlayerData.equipment_data["Ranged"]
	var consumeId = PlayerData.equipment_data["Consumable"]
	
	if swordId != null:
		var swordName = GameData.item_data[str(swordId)]["ItemName"]
		var swordTexture = load("res://ITEMS/ItemIcons/"+swordName+".png")
		swordSprite.texture = swordTexture
	else:
		swordSprite.texture = null
		
	if bowId != null:
		var bowName = GameData.item_data[str(bowId)]["ItemName"]
		bowName = bowName.split(" ",true,1)
		var bowString = str(bowName[0])
		var bowTexture = load("res://Assets/Character/Weapons/Bow"+bowString+".png")
#		print(bowTexture)
		bowSprite.texture = bowTexture
	else:
		bowSprite.texture = null
		
	if consumeId != null:
		var consumeName = GameData.item_data[str(consumeId)]["ItemName"]
		var consumeTexture = load("res://ITEMS/ItemIcons/"+consumeName+".png")
		consumableSprite.position = Vector2(0,0)
		consumableSprite.texture = consumeTexture
	else:
		consumableSprite.texture = null
		
		
func _on_HitBox_area_entered(_body):
	pass


func _on_Player_consume():
	animationPlayer.play("consumeit")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "consumeit":
		var itemId = PlayerData.equipment_data["Consumable"]
		var foodHealth = GameData.item_data[str(itemId)]["ItemFoodRegen"]
		Global.foodTimeOut = false
		PlayerStats.health = min(PlayerStats.health+foodHealth,PlayerStats.maxHealth)
		get_tree().get_root().get_node("SceneHandling/UI/Interface").update_health()
		get_tree().get_root().get_node("SceneHandling/UI/Control/CharacterSheet").clear_single_slot("Consumable",itemId)	
		PlayerData.equipment_data["Consumable"] = null
		get_tree().get_root().get_node("SceneHandling/UI/HotBar").food_consumed(itemId)
		
		update_weaponSprites()
		
		
