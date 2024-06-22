extends Node2D


export var magicFire : PackedScene
export var devilHornSpawn : PackedScene
export var devilBoneSpawn : PackedScene



func _on_ShootTimer_timeout():
	var magicFireInstance = magicFire.instance()
	magicFireInstance.position = position
	get_parent().add_child(magicFireInstance)
