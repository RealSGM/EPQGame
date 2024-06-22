extends Node2D

onready var bowSprite = $Sprite

onready var Player = $"/root/PlayerStats"
onready var detection 


func _process(delta):
	var PlayerPos = player.global_position
	rotation += PlayerPos.angle()
