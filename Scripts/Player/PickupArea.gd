extends Area2D

signal item_found

func _on_PickupArea_body_entered(body):
	Global.items_in_range.append(body)
	emit_signal("item_found",Global.items_in_range)

func _on_PickupArea_body_exited(body):
	if Global.items_in_range.has(body):
		Global.items_in_range.erase(body)
	
