extends KinematicBody2D


var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

export var EnemyDeathEffect : PackedScene

export var ACCELERATION = 300
export var MAX_SPEED = 10
export var FRICTION = 800

#---------AREA VARIABLES-----------#

var damage = 1
var damageEffect = 'None'
var damageName = 'Body'
var damageTaken = 0



enum { 	#Movement
	IDLE,
	WANDER,
	CHASE,
	CHARGE,
	STOMP
	
}

enum {  #Damage States
	FIRE,
	FROZEN,
	POISON,
	BLEED,
	NOTHING
	
}
var miniCoolDown = false
var defaultState = IDLE
var bowHitCount = 0
var DamageState = NOTHING
var state = defaultState
var DamageFromTick = 0
var TickSpeed = 0
var DurationTick = 0
var rng = RandomNumberGenerator.new()

onready var tween = $Tween
onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var Player = $"/root/PlayerStats"
onready var wanderController = $WandereController
onready var animationPlayer = $AnimationPlayer
onready var damageStateSprite = $DamageStates
onready var damageStateController = $DamageStatesController

func _ready():
	BossInfo.bossNode = self
	
	rng.randomize()

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
			BossInfo.bossVelocity = velocity
			seek_player()
			
			if wanderController.get_time_left() == 0:
				state = pick_random_state([WANDER])
				wanderController.start_wander_timer(rand_range(1,3))
			velocity =  move_and_slide(velocity)
				
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
				
			velocity =  move_and_slide(velocity)
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			
			sprite.flip_h = velocity.x < 0
			velocity =  move_and_slide(velocity)
			
		CHARGE:
			BossInfo.bossVelocity = velocity
			if !$AttackingController.charge_cooldown and $Hurtbox/CollisionShape2D.disabled == false:
#				velocity =  Vector2.ZERO
				BossInfo.midCharge = true
				$AttackingController.nature_blast()
			elif !BossInfo.midCharge:
					state = IDLE
					seek_player()
		STOMP:
			BossInfo.bossVelocity = velocity
			if !$AttackingController.stomp_cooldown and $Hurtbox/CollisionShape2D.disabled == false:
				velocity =  Vector2.ZERO
				BossInfo.midStomp = true
				$AttackingController.stomp()

			elif !BossInfo.midStomp:
					state = IDLE
					seek_player()
				

func _process(_delta):
	
	
	match DamageState:
		FIRE:
			damageStateSprite.frame = 1
			DamageFromTick = 2
		POISON:
			damageStateSprite.frame = 0
			DamageFromTick = 1
		FROZEN:
			damageStateSprite.frame = 2
			
		BLEED:
			damageStateSprite.frame = 3
			DamageFromTick = 3
		NOTHING:
			damageStateSprite.frame = 4
			
	if damageTaken >= 15:
		damageTaken = 0
		special_attack()


func _on_Hurtbox_area_entered(area):
	animationPlayer.play("Start")
	if area.areaName == "sword":
		stats.set_health(stats.health - Player.damage)
		knockback = velocity * -15
		Global.music.get_node("MeleeHit").play()
		
		if state != CHARGE:
			state = STOMP
		damageTaken += Player.damage
	
		
	elif area.areaName == "arrow":
		stats.set_health(stats.health - (Player.bowDamage / 2)) 
		knockback = area.knockbackVector * 15
		Global.music.get_node("RangedHit").play()
		
		DamageState = BLEED
		TickSpeed = 3
		DurationTick = 10
		
		bowHitCount += 1
		damageTaken += Player.bowDamage
		
		if state != STOMP:
			state = CHARGE
		
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
	get_parent().add_child(enemyDeathEffect,true)
	enemyDeathEffect.global_position = global_position - Vector2(0,6)
	enemyDeathEffect.flip_h = velocity.x < 0
	Global.currentMusic = "Game"
	#Change to Victory Music

func _on_DamageStatesController_DamageTaken():
	stats.health -= DamageFromTick
	damageStateController.RefreshTick(TickSpeed)
	animationPlayer.play("Start")
	


func _on_DamageStatesController_DurationStop():
	DamageState = NOTHING


func special_attack():
	var chance = rng.randi_range(0,100)
	if chance <= 30:
		if BossInfo.summonedEnemies <= 5:
			$AttackingController.summon_reinforcements()
	elif chance >= 70:
		if $Hurtbox/CollisionShape2D.disabled == false and miniCoolDown == false:
			miniaturize()	
	else:
		MAX_SPEED += 2
		if MAX_SPEED >= 40:
			MAX_SPEED =tween.interpolate_property(self,"MAX_SPEED",40,10,1,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		


func miniaturize():
	stats.health += 25
	for spells in get_children():
		if "Spell" in spells.get_name():
			spells.queue_free()
		
	$MiniTimer.start()
	miniCoolDown = true
	tween.interpolate_property(self,"scale",Vector2(2,2),Vector2(0.5,0.5),1,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	tween.start()
	$PlayerDetectionZone/CollisionShape2D.scale = Vector2(2,2)
	state = CHASE
	modulate = Color(1,1,1,0.8)
	MAX_SPEED += 70
	$Hurtbox/CollisionShape2D.disabled = true
	
	DamageState = NOTHING


func _on_MiniTimer_timeout():
	if $Hurtbox/CollisionShape2D.disabled == true:
		tween.interpolate_property(self,"scale",Vector2(0.5,0.5),Vector2(2,2),1,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		tween.start()
		$PlayerDetectionZone/CollisionShape2D.scale = Vector2(0.5,0.5)
		modulate = Color(1,1,1,1)
		MAX_SPEED -= 70
		$Hurtbox/CollisionShape2D.disabled = false
	else:
		miniCoolDown = false

