extends AnimatedSprite

export var itemDrop: PackedScene
var rng = RandomNumberGenerator.new()

func _ready():
	self.connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("Animate")
	rng.randomize()



func _on_animation_finished():
	visible = false
	GameData.materials_list.shuffle()
	GameData.consumables_list.shuffle()
	
	var chance = rng.randi_range(1,100)
	var itemInstance = itemDrop.instance()
	var dropId
	
	if chance >= 40:	
		dropId = GameData.consumables_list[0]
	else:
		dropId = GameData.materials_list[0]
		
	itemInstance.itemId = dropId
	itemInstance.refresh_drop(itemInstance.itemId)
	itemInstance.position = global_position
	get_tree().get_root().get_node("SceneHandling/Game").call_deferred("add_child",itemInstance)
	
	itemInstance.get_node("Timer").set_wait_time(0.2)
	yield(get_tree().create_timer(0.5), "timeout")	
	itemInstance.get_node("Timer").start()
	
	queue_free()
