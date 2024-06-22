extends Node2D
var inRoom = false
onready var interface = get_tree().get_root().get_node("SceneHandling/UI/Interface") 
#var topDoor = null
#var topDoorSprite = null
#
#var leftDoor = null
#
#var rightDoor = null
#
#var downDoor = null




func _process(_delta):	
	if inRoom == true:
			
		var ChildCount = 0
		var NorthDoor = has_node("TopDoor")
		var EastDoor = has_node("RightDoor")
		var WestDoor = has_node("LeftDoor")
		var SouthDoor = has_node("DownDoor")
		var portal = has_node("Portal")
		var _FakeCount = $YSort.get_child_count()
		for childs in $YSort.get_children():
			if !("Rock" in childs.get_name()):
				ChildCount += 1
		
		if NorthDoor == true:
			var topDoor = $TopDoor/CollisionShape2D
			var topDoorSprite = $TopDoor/Sprite
			if ChildCount == 0:
				topDoor.disabled = true
				topDoorSprite.frame = 0

			else:
				topDoor.disabled = false
				topDoorSprite.frame = 1

		if WestDoor == true:
			var leftDoor = $LeftDoor/CollisionShape2D
			var leftDoorSprite = $LeftDoor/Sprite
			if ChildCount == 0:
				leftDoor.disabled = true
				leftDoorSprite.frame = 1
			else:

				leftDoor.disabled = false
				leftDoorSprite.frame = 0

		if EastDoor == true:
			var rightDoor = $RightDoor/CollisionShape2D
			var rightDoorSprite = $RightDoor/Sprite
			if ChildCount == 0:
				rightDoor.disabled = true
				rightDoorSprite.frame = 1

			else:
				rightDoor.disabled = false
				rightDoorSprite.frame = 0

				
		if SouthDoor == true:
			var downDoor = $DownDoor/CollisionShape2D
			var downDoorSprite = $DownDoor/Sprite
			if ChildCount == 0:
				downDoor.disabled = true
				downDoorSprite.frame = 1

			else:
				downDoor.disabled = false
				downDoorSprite.frame = 0
		if portal == true:
			var portalColl = $Portal/Area2D/CollisionShape2D
			var portalSprite = $Portal/AnimatedSprite
			var Portal = $Portal
			var portalPart = $Portal/Orbital
			print(ChildCount)
			if ChildCount == 0:
				portalColl.disabled = false
				portalSprite.visible = true
				Portal.enabled = true
				portalPart.emitting = true
				





