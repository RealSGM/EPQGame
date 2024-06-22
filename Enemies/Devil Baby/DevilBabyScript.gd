extends KinematicBody2D


var velocity = Vector2.ZERO
var knockback = Vector2.ZERO


export var EnemyDeathEffect : PackedScene

export var ACCELERATION = 300
export var MAX_SPEED = 10
export var FRICTION = 800

#---------AREA VARIABLES-----------#

var damage = 5
var damageEffect = 'None'
var damageName = 'Body'




enum { 	#Movement
	IDLE,
	WANDER,
	CHASE
}

enum {  #Damage States
	FIRE,
	FROZEN,
	POISON,
	BLEED,
	NOTHING
	
}


var DamageState = NOTHING
var state = CHASE
var DamageFromTick = 0
var TickSpeed = 0
var DurationTick = 0


onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var  hurtbox = $Hurtbox
onready var Player = $"/root/PlayerStats"
onready var wanderController = $WandereController
onready var animationPlayer = $AnimationPlayer
onready var damageStateSprite = $DamageStates
onready var damageStateController = $DamageStatesController



func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta )
			seek_player()
			
			if wanderController.get_time_left() == 0:
				state = pick_random_state([WANDER])
				wanderController.start_wander_timer(rand_range(1,3))
		WANDER:
			seek_player()
			
			if wanderController.get_time_left() == 0:
				state = pick_random_state([WANDER])
				wanderController.start_wander_timer(rand_range(1,3))

				
			var direction = global_position.direction_to(wanderController.target_position)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			sprite.flip_h = velocity.x < 0

			if global_position.distance_to(wanderController.target_position) <= 4:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1,3))
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			
			sprite.flip_h = velocity.x < 0
	velocity =  move_and_slide(velocity)
		

func _process(_delta):
	
	match DamageState:
		FIRE:
			damageStateSprite.frame = 1
			DamageFromTick = 2
		POISON:
			damageStateSprite.frame = 0
			DamageFromTick = 3
		FROZEN:
			damageStateSprite.frame = 2
			
		BLEED:
			damageStateSprite.frame = 3
			DamageFromTick = 4
		NOTHING:
			damageStateSprite.frame = 4



func _on_Hurtbox_area_entered(area):
	animationPlayer.play("Start")
	if area.areaName == "sword":
		stats.set_health(stats.health - Player.damage)
		knockback = velocity * -15
		Global.music.get_node("MeleeHit").play()
		
	elif area.areaName == "arrow":
		stats.set_health(stats.health - Player.bowDamage)
		knockback = area.knockbackVector * 15
		DamageState = BLEED
		TickSpeed = 3
		DurationTick = 10
		Global.music.get_node("RangedHit").play()
		damageStateController.StartTimers(DurationTick,TickSpeed)
		
	elif area.areaName == 'MagicFire':
		stats.set_health(stats.health - Player.bowDamage)
		knockback = area.knockbackVector * 15
		DamageState = FIRE
		TickSpeed = 0.5
		DurationTick = 5
		
		damageStateController.StartTimers(DurationTick,TickSpeed)
		



func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position - Vector2(0,6)
	enemyDeathEffect.flip_h = velocity.x < 0


func _on_DamageStatesController_DamageTaken():
	stats.health -= DamageFromTick
	damageStateController.RefreshTick(TickSpeed)
	animationPlayer.play("Start")
	


func _on_DamageStatesController_DurationStop():
	DamageState = NOTHING
func freeze_node(node, freeze):
	node.set_process(!freeze)
	node.set_physics_process(!freeze)
	node.set_process_input(!freeze)
	node.set_process_internal(!freeze)
	node.set_process_unhandled_input(!freeze)
	node.set_process_unhandled_key_input(!freeze)

func freeze_scene(node, freeze):
	freeze_node(node, freeze)
	for c in node.get_children():
		freeze_scene(c, freeze)
