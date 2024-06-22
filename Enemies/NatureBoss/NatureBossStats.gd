extends Node


onready var health = 200 setget set_health

signal no_health

func set_health(value):
	
	health = value
	print("DH HEALTH: ",health)
	if health <= 0:
		emit_signal("no_health")
	



