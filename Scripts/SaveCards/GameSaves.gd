extends CanvasLayer

export var gamePopUp: PackedScene
export var newGame: PackedScene
export var continueGame: PackedScene

func _ready():
	refresh_saves()
	for child in get_children():
		child.visible = false

func refresh_saves():
	var count = 0
	for card in range(3):
		var newCard = get_child(card)
		var _gameInstance
		newCard.rect_position = Vector2(43 + count,44)
		
		for child in newCard.get_children():
			child.queue_free()
		
		var saveFile = File.new()
		if saveFile.file_exists(Global.cardPath[card]):
			_gameInstance = continueGame.instance()
			_gameInstance.connect("continue_game",get_tree().get_root().get_node("SceneHandling"),"continue_game")
			_gameInstance.connect("delete_save",get_tree().get_root().get_node("SceneHandling"),"delete_save")
		else:
			_gameInstance = newGame.instance()
			_gameInstance.connect("new_game",get_tree().get_root().get_node("SceneHandling"),"new_game")
			
			
		newCard.add_child(_gameInstance)

		count += newCard.rect_size.x + 10
