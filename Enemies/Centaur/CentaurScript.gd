extends KinematicBody2D


var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

export var EnemyDeathEffect : PackedScene

export var ACCELERATION = 300
export var MAX_SPEED = 10
export var FRICTION = 800







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


var xCoord = 0
var xNeg = false
var offsetVector = Vector2(0,0) 
var count = 0
var yNeg = false

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var  hurtbox = $Hurtbox
onready var Player = $"/root/PlayerStats"
onready var wanderController = $WandereController
onready var animationPlayer = $AnimationPlayer
onready var damageStateSprite = $DamageStates
onready var damageStateController = $DamageStatesController
onready var bowSprite = $BowSprite


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
			wanderController.wander_range = 50
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
				var direction = (player.global_position - global_position + offsetVector).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED * 5, ACCELERATION * delta)

			
			else:
						
				state = IDLE
			
			sprite.flip_h = velocity.x < 0
	velocity =  move_and_slide(velocity)
		


func _process(_delta):
	var player = playerDetectionZone.player
	if player != null:
		var PlayerPos = player.global_position
		bowSprite.rotate(bowSprite.get_angle_to(PlayerPos)+0.785398)
		
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
		knockback = velocity * -1
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


func _on_NewOffsetTarget_timeout():
	var radius = 60
	if xNeg == false:
		xCoord += 0.5
		if xCoord == radius:
			xNeg = true
		if xCoord == 49.5:
			yNeg = false
	if xNeg == true:
		xCoord -= 0.5
		if xCoord == -radius:
			xNeg = false
		if xCoord == -49.5:
			yNeg = true
	var yCoord = sqrt((pow(radius,2))-(pow(xCoord,2)))
	if yNeg == true:
		yCoord = yCoord * -1
	
	offsetVector = Vector2(xCoord,yCoord)
	return(offsetVector)


export var arrowScene : PackedScene


func _on_BowTimer_timeout():
	var player = playerDetectionZone.player
	var _Player_pos = null
	if player != null:
		_Player_pos = player.global_position
	var arrowInstance = arrowScene.instance()
	arrowInstance.position = position
	get_parent().add_child(arrowInstance)



