extends Control

onready var bottom_line = $VBranch

onready var top_line = $VBranch2

onready var left_line = $HBranch

onready var right_line = $HBranch2

onready var button = $TextureButton

onready var price_text = $ColorRect/BoxContainer/Label

onready var price_block = $ColorRect

func set_actived():
	bottom_line.modulate = Color.darkviolet
	top_line.modulate = Color.darkviolet
	left_line.modulate = Color.darkviolet
	right_line.modulate = Color.darkviolet

	button.button_mask = 0
	button.set_toggle_mode(true)
	button.pressed = true

func _unlock():
	button.disabled = false

func _lock():
	button.disabled = true
	button.set_toggle_mode(true)
	button.pressed = false

func _deselect():
	button.pressed =  false

func _set_price(value):
	price_text.text = str(value)

func _ready():
	_lock()
	price_block.hide()

func _on_TextureButton_mouse_entered():
	price_block.show()



func _on_TextureButton_focus_entered():
	price_block.show()

func _on_TextureButton_mouse_exited():
	price_block.hide()


func _on_TextureButton_focus_exited():
	price_block.hide()

func activated()-> bool:
	return button.pressed;
