extends Camera2D

var positionCheck = Vector2()

func _process(_delta):
	if PlayerStats.health > 0:
		if has_node("../YSort/Player"):
			var pos = get_node("../YSort/Player").position - Vector2(0,0)
			var x = floor(pos.x / 320 ) * 320
			var y = floor(pos.y / 176 ) * 176
			
			global_position = Vector2(x,y)
			if positionCheck != Vector2(x,y):
				pause_enemy(Vector2(x,y))
				camera_moved()
			positionCheck = Vector2(x,y)



func _ready():
	pause_enemy(Vector2(0,0))

func pause_enemy(positionCamera):
	for child in get_node("../MapNode").get_children():
		var roomPos = child.global_position
		var xRoom = floor(roomPos.x / 320 ) * 320
		var yRoom  = floor(roomPos.y / 176 ) * 176
		var positionRoom = Vector2(xRoom,yRoom)
		if positionRoom == positionCamera:
			child.inRoom = true
		var ySort = child.get_node('YSort')
		if ySort != null:
			for enemy in ySort.get_children():
				var pos = enemy.global_position
				var x = floor(pos.x / 320 ) * 320
				var y = floor(pos.y / 176 ) * 176
				var positionEnemy = Vector2(x,y)
				if positionEnemy != positionCamera:
					freeze_scene(enemy,false)
				else:				
					freeze_scene(enemy,true)

func freeze_node(node, freeze):
	node.set_process(freeze)
	node.set_physics_process(freeze)
	node.set_process_input(freeze)
	node.set_process_internal(freeze)
	node.set_process_unhandled_input(freeze)
	node.set_process_unhandled_key_input(freeze)

func freeze_scene(node, freeze):
	freeze_node(node, freeze)
	for c in node.get_children():
		freeze_scene(c, freeze)

func camera_moved():
	var interface = get_tree().get_root().get_node("SceneHandling/UI/Interface") 
	interface.modulate = Color(1,1,1,0.5)
	PlayerStats.mana = PlayerStats.maxMana
	PlayerStats.health = PlayerStats.maxHealth
	interface.update_mana()
	interface.update_health()
