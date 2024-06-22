extends Area2D


var areaName = "arrow"
var speed = 5
var movement = Vector2()
onready var mouse_pos = null
var knockbackVector = Vector2.ZERO
var player_pos = null
var look_vec = Vector2.ZERO


func _ready():
	player_pos = get_tree().get_root().get_node('SceneHandling/Game/Player').global_position
	player_pos = _playerOffset(player_pos)
	look_vec = player_pos - global_position
	rotation = get_angle_to(player_pos)

func _physics_process(delta):
	movement = movement.move_toward(look_vec,delta)
	movement = movement.normalized() * speed
	position = position + movement
	knockbackVector = movement
	
	
	
func _on_Area2D_area_entered(_area):
	queue_free()


func _playerOffset(position):
	randomize()
	var randomOffset = rand_range(-20,20)
	position = Vector2(position.x+randomOffset,position.y+randomOffset)
	return(position)
