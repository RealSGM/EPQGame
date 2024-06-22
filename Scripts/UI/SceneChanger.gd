extends CanvasLayer

signal transitioned

func transition():
	$AnimationPlayer.play("fade_to_black")
	
func _on_AnimationPlayer_animation_finished(animName):
	if animName == "fade_to_black":
		emit_signal("transitioned")
	
		
