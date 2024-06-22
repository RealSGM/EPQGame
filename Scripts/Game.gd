extends Node2D

export var _1E: PackedScene
export var _1N: PackedScene
export var _1S: PackedScene
export var _1W: PackedScene

export var _1EEnd: PackedScene
export var _1NEnd: PackedScene
export var _1SEnd: PackedScene
export var _1WEnd: PackedScene


export var _2NE: PackedScene
export var _2SE: PackedScene
export var _2SN: PackedScene
export var _2SW: PackedScene
export var _2WE: PackedScene
export var _2WN: PackedScene
export var _3SNE: PackedScene
export var _3SWE: PackedScene
export var _3SWN: PackedScene
export var _3WNE: PackedScene
export var _4SWNE: PackedScene
export var Spawn: PackedScene
export var itemDrop: PackedScene


var dungeon = {}
var connections = []
var cardinalDirections = []
var counter = 0


onready var map_node = $MapNode


func forge_entered(body):
	if body.has_node("PickupArea"):
		Global.pause_game()
		get_node("../UI/Control/Inventory").visible = true
		get_node("../UI/Control/ForgeUI").visible = true

func shop_entered(body):
	
	if body.has_node("PickupArea"):
		Global.pause_game()
		get_node("../UI/Control/Bin").visible = true
		get_node("../UI/Control/CoinDisplay").visible = true
		get_node("../UI/Control/Inventory").visible = true
		get_node("../UI/Control/ShopUI").visible = true


func _ready():
	set_name("Game")
	$TempBlack.visible = true
	PlayerData.playerNode = $YSort/Player
	PlayerData.playerNode.visible = false
	
	randomize()
	connections = [[0]]
	$CanvasModulate.color = Color(0.454902,0.262745,0.262745,1)
	while connections[0][0] != 4:
		var dungeonReturn = generate(rand_range(-1000, 1000))
		connections = dungeonReturn.dungeonLayout
		dungeon = dungeonReturn.dungeon
		cardinalDirections = dungeonReturn.cardinalConnections
	
	load_map()
	$Camera2D.pause_enemy(Vector2(0,0))
	
	Global.paused = false
	get_tree().paused = false
	
	Global.currentScene = "Game"
	Global.sceneTransitioned = true	
	Global.currentMusic = "Game"
	PlayerData.playerNode = get_node("YSort/Player")
	
	$TempBlack.queue_free()
	PlayerData.playerNode.visible = true
	
	yield(get_tree().create_timer(1), "timeout")
	get_node("../SceneChanger").queue_free()
	
	$CanvasModulate.color = Color(0.454902,0.262745,0.262745,1)
	$Shop/Texture/Area2D.connect("body_entered",self,"shop_entered")
	$Forge/Texture/AreaForge.connect("body_entered",self,"forge_entered")
	
	

	

	

#	var rng = RandomNumberGenerator.new()
#	rng.randomize()
#
#	for _i in range(30):
#		var itemInstance = itemDrop.instance()
#		itemInstance.itemId = rng.randi_range(10000,10199)
#		itemInstance.refresh_drop(itemInstance.itemId)
#		itemInstance.position = Vector2(rng.randi_range(20,290),rng.randi_range(20,150))
#		add_child(itemInstance)
#		yield(get_tree().create_timer(0.5), "timeout")	

func load_map():
	for i in range(0, map_node.get_child_count()):
		map_node.get_child(i).queue_free()
		
	counter = 0
	for i in dungeon.keys():
		var temp
		match connections[counter][0]:
			1:
				if (counter+1) == len(dungeon):
					match cardinalDirections[counter]:
						'E':
							temp = _1EEnd.instance()
						'N':
							temp = _1NEnd.instance()
						'S':
							temp = _1SEnd.instance()
						'W':
							temp = _1WEnd.instance()
				else:
					match cardinalDirections[counter]:
						'E':
							temp = _1E.instance()
						'N':
							temp = _1N.instance()
						'S':
							temp = _1S.instance()
						'W':
							temp = _1W.instance()
			2:
				match cardinalDirections[counter]:
					'NE':
						temp = _2NE.instance()
					'SE':
						temp = _2SE.instance()
					'SN':
						temp = _2SN.instance()
					'SW':
						temp = _2SW.instance()
					'WE':
						temp = _2WE.instance()
					'WN':
						temp = _2WN.instance()
			3:
				match cardinalDirections[counter]:
					"SNE":
						temp = _3SNE.instance()
					"SWE":
						temp = _3SWE.instance()
					"SWN":
						temp = _3SWN.instance()
					"WNE":
						temp = _3WNE.instance()
			4:
				if counter == 0:
					temp = Spawn.instance()
				else:
					temp = _4SWNE.instance()
				
		map_node.add_child(temp,true)
		temp.position = Vector2(i[0] * 320,i[1] * 176)
		counter += 1

func _on_Button_pressed():
	randomize()
	var dungeonReturn = generate(rand_range(-1000, 1000))
	dungeon = dungeonReturn.dungeon
	connections = dungeonReturn.dungeonLayout
	cardinalDirections = dungeonReturn.cardinalConnections
	load_map()

#-----------------------------GENERATION OF MAP-------------------------------------#

export var room: PackedScene
var minNumberRooms = 10
var maxNumberRooms = 20
var genChance = 10

func generate(room_seed):
	randomize()
	seed(room_seed)
	var dungeon = {}
	var size = floor(rand_range(minNumberRooms, maxNumberRooms))
	var _maxsize = size
	var dungeonLayout = []
	var cardinalConnections = []
	
	dungeon[Vector2(0,0)] = room.instance()
	size -= 1
	
	while(size > 0):
		var direction
		for i in dungeon.keys():
			if(rand_range(0,100) < genChance):
				
				direction = rand_range(0,4)
				
				if(direction < 1):
					var newRoomPosition = i + Vector2(1, 0)
					if(!dungeon.has(newRoomPosition)):
						dungeon[newRoomPosition] = room.instance()
						size -= 1
					if(dungeon.get(i).connected_rooms.get(Vector2(1, 0)) == null):
						connect_rooms(dungeon.get(i), dungeon.get(newRoomPosition), Vector2(1, 0))
				elif(direction < 2):
					var newRoomPosition = i + Vector2(-1, 0)
					if(!dungeon.has(newRoomPosition)):
						dungeon[newRoomPosition] = room.instance()
						size -= 1
					if(dungeon.get(i).connected_rooms.get(Vector2(-1, 0)) == null):
						connect_rooms(dungeon.get(i), dungeon.get(newRoomPosition), Vector2(-1, 0))
				elif(direction < 3):
					var newRoomPosition = i + Vector2(0, 1)
					if(!dungeon.has(newRoomPosition)):
						dungeon[newRoomPosition] = room.instance()
						size -= 1
					if(dungeon.get(i).connected_rooms.get(Vector2(0, 1)) == null):
						connect_rooms(dungeon.get(i), dungeon.get(newRoomPosition), Vector2(0, 1))
				elif(direction < 4):
					var newRoomPosition = i + Vector2(0, -1)
					if(!dungeon.has(newRoomPosition)):
						dungeon[newRoomPosition] = room.instance()
						size -= 1
					if(dungeon.get(i).connected_rooms.get(Vector2(0, -1)) == null):
						connect_rooms(dungeon.get(i), dungeon.get(newRoomPosition), Vector2(0, -1))
						
	for i in dungeon.keys():
		var _temp_array = [dungeon.get(i).number_of_connections]
		var _temp_array2 = [i,dungeon.get(i).number_of_connections]
		var _temp_String_Cardinal = ''
		dungeonLayout.append(_temp_array)		
		if dungeon.get(i).connected_rooms.get(Vector2(0, 1)) != null:
			_temp_String_Cardinal += 'S'
		if dungeon.get(i).connected_rooms.get(Vector2(-1, 0)) != null:
			_temp_String_Cardinal += 'W'
		if dungeon.get(i).connected_rooms.get(Vector2(0, -1)) != null:
			_temp_String_Cardinal += 'N'
		if dungeon.get(i).connected_rooms.get(Vector2(1, 0)) != null:
			_temp_String_Cardinal += 'E'

#		print(i,_temp_String_Cardinal)
		cardinalConnections.append(_temp_String_Cardinal)

	return {
		dungeonLayout = dungeonLayout,
		dungeon = dungeon,
		cardinalConnections = cardinalConnections
		}
	
	
func connect_rooms(room1, room2, direction):
	room1.connected_rooms[direction] = room2
	room2.connected_rooms[-direction] = room1
	room1.number_of_connections += 1
	room2.number_of_connections += 1



