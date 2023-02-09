extends Control

onready var pointer = $Pointer/Pointer
onready var text = $Answer/Text
# Called when the node enters the scene tree for the first time.
func _ready():
	pointer.hide()


func set_text(_text):
	text.text = _text


# func _on_ChoiceA_mouse_entered():
# 	pointer.show()


# func _on_ChoiceA_mouse_exited():
# 	pointer.hide()



func _on_Answer_mouse_exited():
	pointer.hide()

func _on_Answer_mouse_entered():
	pointer.show()
