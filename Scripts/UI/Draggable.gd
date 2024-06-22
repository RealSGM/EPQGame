extends KinematicBody2D

var draggingDistance
var dir
var dragging
var newPosition = Vector2()

var mouseIn = false
var chosen = false

func _input(event):
	if event is InputEventMouseButton:
		if chosen and event.is_pressed() && mouseIn:
			draggingDistance = position.distance_to(get_viewport().get_mouse_position())
			dir = (get_viewport().get_mouse_position() - position).normalized()
			dragging = true
			newPosition = get_viewport().get_mouse_position() - draggingDistance * dir
		else:
			dragging = false
			chosen = false
			
	elif event is InputEventMouseMotion:
		if dragging:
			newPosition = get_viewport().get_mouse_position() - draggingDistance * dir

func _physics_process(delta):
	if dragging:
		move_and_slide((newPosition - position) * Vector2(30, 30))


func chosen():
	chosen = true
	
func mouse_entered():
	mouseIn = true

func mouse_exited():
	mouseIn = false
