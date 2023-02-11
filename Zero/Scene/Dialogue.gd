extends CanvasLayer

signal choice_end

onready var text_timer = $TextTimer

onready var dialogue_text = $Dialog/VBoxContainer/Label

#character
onready var charater_a = $NarratorA
onready var charater_b = $NarratorB

#choices
onready var choice_a = $Dialog/VBoxContainer/Choices/ChoiceA
onready var choice_b = $Dialog/VBoxContainer/Choices/ChoiceB
onready var choice_c = $Dialog/VBoxContainer/Choices/ChoiceC

onready var choices = $Dialog/VBoxContainer/Choices

var skip = false

var ans = ""

var show_text = ""

func show_dialog():
	show()
	dialogue_text.text = ""
	for i in range(show_text.length()):
		dialogue_text.text = show_text.substr(0,i + 1)
		yield(text_timer,"timeout")
		if(skip):
			skip = false
			dialogue_text.text =show_text
			break
	choices.show()
	yield (self,"choice_end")


func _input(_event):
	if(Input.is_action_just_pressed("skip")):
		skip = true;

func _ready():
	
	_reset()


func _reset():
	charater_a.hide()
	charater_b.hide()

	choice_a.hide()
	choice_b.hide()
	choice_c.hide()

	choices.hide()
	dialogue_text.text = ""
	show_text = ""
	hide()

func set_choice(choice, text):
	if(choice.to_lower() == "a"):
		choice_a.set_text(text)
		choice_a.show()
	elif choice.to_lower() == "b":
		choice_b.set_text(text)
		choice_b.show()
	elif choice.to_lower() == "c":
		choice_c.set_text(text)
		choice_c.show()



func _on_choice_c_pressed():
	_reset()
	ans = "c"
	emit_signal("choice_end")


func _on_choice_b_pressed():
	_reset()
	ans = "b"
	emit_signal("choice_end")

func _on_choice_a_pressed():
	_reset()
	ans = "a"
	emit_signal("choice_end")
	
func read_json():
	_reset()
	#not finish

func set_character(character,name):
	if character.to_lower() == "a":
		charater_a.show()
		charater_a.set_name(name)
	elif character.to_lower() == "b":
		charater_b.show()
		charater_b.set_name(name)

func set_text(_text):
	show_text = _text

# 1. set character
# 2. set text
# 3. set choices

# finally, show_dialog 
