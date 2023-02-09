extends Control

export(Vector2) var _start_position = Vector2(0, -20)
export(Vector2) var _end_position = Vector2.ZERO
export(float) var fade_in_duration = 0.3
export(float) var fade_out_duration = 0.2

onready var healSkill = $NinePatchRect/Heal
onready var sliderSkill = $NinePatchRect/Slide
onready var jumpSkill = $NinePatchRect/Double
onready var gunSkill = $NinePatchRect/Gun
onready var doubleCoin = $NinePatchRect/DoubleCoin
onready var trippleCoin = $NinePatchRect/TripleCoin
onready var moreStanima = $NinePatchRect/StanimaA
onready var moremoreStanima = $NinePatchRect/StanimaB

onready var tween = $Tween

onready var back_button = $NinePatchRect/BackButton

func _ready():
	hide()

func _on_BackButton_pressed():
	_close()

func _open():
	show()
	back_button.grab_focus()
	tween.interpolate_property(self, "modulate:a", 0.0, 1.0,
			fade_in_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)

	tween.start()

func _close():
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0,
			fade_out_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)

	tween.start()



func _on_Tween_tween_all_completed():
	if modulate.a < 0.5:
		hide()

func _unhandled_input(event):
	if event.is_action_pressed("toggle_pause") and visible:
		_close()
		get_tree().set_input_as_handled()
