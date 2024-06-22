extends Area2D


func _on_Area2D_body_shape_entered(_body_id, _body, _body_shape, _local_shape):
	get_tree().get_root().get_node("SceneHandling").enter_portal()

