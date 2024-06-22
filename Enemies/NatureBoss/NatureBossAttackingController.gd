extends Node2D


export var natureBlast : PackedScene
export var natureChild : PackedScene
export var stompAttack : PackedScene


var charge_cooldown
var stomp_cooldown

var spawningPairs = [Vector2(0,-40),Vector2(40,40),Vector2(0,40),Vector2(-40,-40)]

func nature_blast():

	for count in range(4):	
		var natureBlastInstance = natureBlast.instance()
		natureBlastInstance.x = count * 10
		natureBlastInstance.y = count * 10
		natureBlastInstance.position = position
		get_parent().add_child(natureBlastInstance,true)
		
	
	
	charge_cooldown = true
	$ShootTimer.start()

func summon_reinforcements():
	print("Hello!")
	for count in range(4):
		var minionInstance = natureChild.instance()	
		minionInstance.global_position = global_position + spawningPairs[count]
		if !(BossInfo.bossNode.position.x > 32 and BossInfo.bossNode.position.y > 32):
			print("Invalid Spawn")
		minionInstance.get_node("Stats").set_health(1)
		get_parent().get_parent().call_deferred("add_child",minionInstance,true)
		yield(get_tree().create_timer(0.2), "timeout")

func stomp():
	stomp_cooldown = true
	$StompTimer.start()
	get_parent().get_node("AnimatedSprite").animation = "stomp"


func _on_ShootTimer_timeout():
	charge_cooldown = false

func _on_StompTimer_timeout():
	stomp_cooldown = false


func _on_AnimatedSprite_animation_finished():
	if get_parent().get_node("AnimatedSprite").animation == "stomp":
		get_parent().get_node("AnimatedSprite").animation = "default"
		BossInfo.midStomp = false
		BossInfo.midStompEffect = true
		var stompInstance = stompAttack.instance()
		stompInstance.position = position
		get_parent().add_child(stompInstance)
			
	
