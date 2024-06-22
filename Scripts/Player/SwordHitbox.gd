extends "res://Scripts/Player/HitBox.gd"

var knockbackVector = Vector2.ZERO
var areaName = "sword"

func _ready():
	$CollisionShape2D.disabled = true
