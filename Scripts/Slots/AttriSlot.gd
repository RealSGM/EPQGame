extends TextureButton

var attriName
var attriId
signal attri_toggled

func _on_TextureButton_pressed():
#	print(attriName)
	pass

func _on_TextureButton_toggled(_button_pressed):
	emit_signal("attri_toggled",attriId,self)
