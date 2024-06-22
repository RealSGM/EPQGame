extends AnimatedSprite

export var itemDrop: PackedScene

func _ready():
	self.connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("Animate")



func _on_animation_finished():
	visible = false

	var itemInstance = itemDrop.instance()
	
		
	itemInstance.itemId = 10143
	itemInstance.refresh_drop(itemInstance.itemId)
	itemInstance.position = global_position
	get_tree().get_root().get_node("SceneHandling/Game").call_deferred("add_child",itemInstance)
	
	itemInstance.get_node("Timer").set_wait_time(0.2)
	yield(get_tree().create_timer(0.5), "timeout")	
	itemInstance.get_node("Timer").start()
	
	queue_free()

