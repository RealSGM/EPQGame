extends StaticBody2D

export var RockEffect: PackedScene
export var itemDrop: PackedScene
export  var rockh1: Texture
export  var rockh2: Texture
var health = 3

func create_rock_effect():
	var rockEffect = RockEffect.instance()
	get_parent().add_child(rockEffect)
	rockEffect.global_position = global_position
	


func _on_Hurtbox_area_entered(_area):

	if str(PlayerData.equipment_data["Melee"]) in GameData.pickaxe_list:
		health = 0
	else:
		health = max(health-1,0)
		
		
	match health:
		0:		
			$Sprite.texture = null
			$CollisionShape2D.queue_free()
			$Hurtbox.queue_free()
			create_rock_effect()
			Global.music.get_node("RockBreak").play()
			var tempId
			
			if rand_range(0,100) > 11:
				GameData.shard_list.shuffle()
				tempId = GameData.shard_list[0]
			else:
				GameData.plate_list.shuffle()
				tempId = GameData.plate_list[0]

			var itemInstance = itemDrop.instance()
			itemInstance.itemId = tempId
			itemInstance.refresh_drop(itemInstance.itemId)
			itemInstance.position = global_position + Vector2(8,8)
			
			
			get_tree().get_root().get_node("SceneHandling/Game").call_deferred("add_child",itemInstance)		
			yield(get_tree().create_timer(0.5), "timeout")	
			itemInstance.get_node("Timer").set_wait_time(0.2)
			itemInstance.get_node("Timer").start()
			queue_free()
		1:
			$Sprite.texture = rockh1
			Global.music.get_node("RockHit").play()
		2:
			$Sprite.texture = rockh2
			Global.music.get_node("RockHit").play()

	
