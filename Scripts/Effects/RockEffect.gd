extends AnimatedSprite

export var itemDrop: PackedScene
var rng = RandomNumberGenerator.new()

func _ready():
	self.connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("Animate")
	rng.randomize()



func _on_animation_finished():
	queue_free()
