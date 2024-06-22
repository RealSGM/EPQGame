extends Area2D


var damage = 3
var damageEffect = null
var damageName = "Arrow"
var stompKB = 10

onready var animationPlayer = $AnimationPlayer


func _ready():
	animationPlayer.play("Start")
	
func stomp_finished():
	queue_free()
	BossInfo.bossNode.velocity = BossInfo.bossVelocity
	BossInfo.bossNode.state = BossInfo.bossNode.defaultState
	BossInfo.midStompEffect = false


		
