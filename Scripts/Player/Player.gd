extends KinematicBody2D

const FRICTION = 2000
const MAX_SPEED = 90
const ACCELERATION = 600
const ROLL_SPEED = 150
const STRENGTH = 2

var state = MOVE
var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var rollVector = Vector2.LEFT
var stats = PlayerStats
var rarity = "Peasant"
var bowDelay = PlayerStats.bowDelay
var mousePosToPlayer = get_global_mouse_position()

var DamageState = NOTHING
var DamageFromTick = 0
var TickSpeed = 0
var DurationTick = 0

enum {
	MOVE,
	ROLL,
	NONE
}

enum {  #Damage States
	FIRE,
	FROZEN,
	POISON,
	BLEED,
	NOTHING
	
}

onready var fireEffect = $FireEffect
onready var bloodEffect = $BloodEffect
onready var damageStateController = $DamageStatesController
onready var damageStateSprite = $DamageStates
onready var animationPlayer = $AnimationPlayer
onready var hurtbox = $Hurtbox
onready var sprite = $Sprite
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var timer = $"/root/PlayerStats/BowTimer"
onready var weaponControl = $WeaponController
export var arrowScene: PackedScene
var hotbarSlot = Global.equippedSlot
export var magicScene : PackedScene

signal arrow_sent
signal melee_attack
signal reduce_mana
signal reduce_health
signal game_over
signal consume

func _input(event):
	
	if !get_tree().get_root().get_node("SceneHandling").has_node("Lobby"):
		hotbarSlot = Global.equippedSlot
		if PlayerData.equipment_data[hotbarSlot] != null:
			match hotbarSlot:
				"Ranged":
					if event.is_action_pressed("bow_attack") and PlayerStats.bowReady == true and state != ROLL and PlayerStats.mana > 0:
						
						var arrowInstance = arrowScene.instance()
						arrowInstance.position = get_global_position() - Vector2(0,-3)
						get_parent().add_child(arrowInstance)
						emit_signal("arrow_sent")
						
						PlayerStats.bowReady = false
						timer.start(bowDelay)
						
						PlayerStats.mana -= 0.5
						get_tree().get_root().get_node("SceneHandling/UI/HotBar/Timer").start()
						emit_signal("reduce_mana")
						
				"Melee":
					if event.is_action_pressed("melee_attack") and PlayerStats.bowReady == true and state != ROLL:
						get_tree().get_root().get_node("SceneHandling/UI/HotBar/Timer").start()
						emit_signal("melee_attack")
						
				"Spell":
					if event.is_action_pressed("Magic_attack") and PlayerStats.bowReady == true and state != ROLL and PlayerStats.mana > 0:
						
						var arrowInstance = arrowScene.instance()
						arrowInstance.position = get_global_position() - Vector2(0,-3)
						get_parent().add_child(arrowInstance)
						emit_signal("arrow_sent")
						
						PlayerStats.bowReady = false
						timer.start(bowDelay)
						
						PlayerStats.mana -= 0.5
						get_tree().get_root().get_node("SceneHandling/UI/HotBar/Timer").start()
						emit_signal("reduce_mana")
				
				"Consumable":
					if event.is_action_pressed("melee_attack") and PlayerStats.bowReady == true and state != ROLL and Global.foodTimeOut == true:
						emit_signal("consume")
				
						
				
func _ready():
	stats.connect("no_health", self, "game_over")
	stats.health = 10 

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		NONE: 
			pass
	
func _process(_delta):
	if !(weaponControl.aniIfPlaying != "" and Global.equippedSlot == "Melee"):
		mousePosToPlayer = get_angle_to(get_global_mouse_position())
		mousePosToPlayer = pow(mousePosToPlayer, 2)
		if mousePosToPlayer > 2 :
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		
	match DamageState:
		FIRE:
			damageStateSprite.frame = 1
			DamageFromTick = 0.5
			fireEffect.emitting = true
		POISON:
			damageStateSprite.frame = 0
			DamageFromTick = 3
		FROZEN:
			damageStateSprite.frame = 2
			
		BLEED:
			damageStateSprite.frame = 3
			DamageFromTick = 4
			bloodEffect.emitting = true
			
		NOTHING:
			damageStateSprite.frame = 4
		
		
func move_state(delta):	
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") -  Input.get_action_strength("ui_up")
	inputVector = inputVector.normalized()
	
	if inputVector != Vector2.ZERO:
		if Global.music.get_node("Footstep").playing == false:
			Global.music.get_node("Footstep").play()
		rollVector = inputVector
		animationPlayer.play("RunRight")
		velocity = velocity.move_toward(inputVector * MAX_SPEED, ACCELERATION * delta)
	else:
		Global.music.get_node("Footstep").stop()
		animationPlayer.play("IdleRight")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	if Input.is_action_just_pressed("roll"):
		state = ROLL
		Global.music.get_node("Footstep").stop()
	velocity = move_and_slide(velocity)


func move():
	velocity = move_and_slide(velocity)
	
func attack_animation_finished():
	state = MOVE
	
func roll_state():
	velocity = rollVector * ROLL_SPEED
	animationPlayer.play("RollRight")
	move()
	
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	$HitSound.play()
	emit_signal("reduce_health")
	hurtbox.start_invincibility(0.6)
	blinkAnimationPlayer.play("Start")
	match area.damageEffect:
		"None":
			pass
		"Fire":
			DamageState = FIRE
			TickSpeed = 0.5
			DurationTick = 3
			
			damageStateController.StartTimers(DurationTick,TickSpeed)
		"Bleed":
			DamageState = BLEED
			TickSpeed = 3
			DurationTick = 10
			
			damageStateController.StartTimers(DurationTick,TickSpeed)
			


func _on_DamageStatesController_DamageTaken():
	stats.health -= DamageFromTick
	emit_signal("reduce_health")
	damageStateController.RefreshTick(TickSpeed)
	blinkAnimationPlayer.play("Start")

func _on_DamageStatesController_DurationStop():
	DamageState = NOTHING
	fireEffect.emitting = false
	bloodEffect.emitting = false

func game_over():
	queue_free()
	get_tree().get_root().get_node("SceneHandling/MusicNCounter/GameOver").play()
	emit_signal("game_over")
	
	
