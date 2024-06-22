extends Node


onready var health = 1 setget set_health

signal no_health

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
	



