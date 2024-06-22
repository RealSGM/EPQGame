extends AnimatedSprite
onready var DevilBaby = preload ("res://Enemies/Devil Baby/DevilBaby.tscn")

func _ready():
	self.connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("Animate")



func _on_animation_finished():
	var devilBaby = DevilBaby.instance()
	get_parent().add_child(devilBaby)
	devilBaby.global_position = global_position - Vector2(2,-7)


	var devilBaby2 = DevilBaby.instance()
	get_parent().add_child(devilBaby2)
	devilBaby2.global_position = global_position + Vector2(2,7)

	
	queue_free()
	
