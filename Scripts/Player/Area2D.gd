extends Area2D

var areaName = "arrow"
var speed = 5
var movement = Vector2()
onready var mouse_pos = null
var knockbackVector = Vector2.ZERO


func _ready():
	mouse_pos = get_local_mouse_position()
	rotation = get_angle_to(get_global_mouse_position())
	
func _physics_process(delta):
	movement = movement.move_toward(mouse_pos,delta)
	movement = movement.normalized() *speed
	position = position + movement
	knockbackVector = movement
	
func _on_Area2D_area_entered(_area):
	$ArrowHit.play()
	$Sprite.texture = null
	$CollisionShape2D.set_deferred("disabled",true)
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()


func _on_Area2D_body_shape_entered(_body_id, _body, _body_shape, _local_shape):

	$ArrowHit.play()
#	$Sprite.texture = null
#	$CollisionShape2D.shape = null
	speed = 0
	yield(get_tree().create_timer(10), "timeout")
	queue_free()



