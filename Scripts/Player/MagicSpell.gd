extends Area2D


#---------AREA VARIABLES-----------#

var damage = 10 * PlayerStats.MODIFIER
var damageEffect = 'Fire'
var damageName = 'Arrow'


var speed = 0
var movement = Vector2()
onready var mouse_pos = null
var knockbackVector = Vector2.ZERO
var player_pos = null
var look_vec = Vector2.ZERO
onready var attackParticles = $SpellParticles
onready var animationPlayer = $AnimationPlayer



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

func _ready():
	animationPlayer.play("Start")
	
func _on_load_finish():
	attackParticles.visible = true
	speed = 1
	if get_tree().get_root().has_node('SceneHandling/Game/YSort/Player'):
		player_pos = get_tree().get_root().get_node('SceneHandling/Game/YSort/Player').global_position
		player_pos = _playerOffset(player_pos)
		look_vec = player_pos - global_position
		rotation = get_angle_to(player_pos) + PI
