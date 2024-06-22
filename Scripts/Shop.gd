extends Node2D


func _ready():
	if Global.newLevel == true:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		for slot in range(8):
			var key = "Shop" + str(slot+1)
			slot = int(slot) / 2

			for list in GameData.all_list:
				list.shuffle()	

			Global.shop_data[key]["Item"] = GameData.all_list[slot][0]
			
	get_tree().get_root().get_node("SceneHandling/UI/Control/ShopUI").refresh_store()




func _on_Timer_timeout():
	$AnimationPlayer.play("shop_move")
	$Timer.start(rand_range(30,60))
