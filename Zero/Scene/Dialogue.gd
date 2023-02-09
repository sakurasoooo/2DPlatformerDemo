extends CanvasLayer

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

func show_text(character,text):
	
	if(character.to_lower() == "a"):
		charater_a.show()
	elif character.to_lower() == "b":
		charater_b.show()
	dialogue_text.text = ""
	for i in range(text.length()):
		dialogue_text.text = text.substr(0,i + 1)
		yield(text_timer,"timeout")
		if(skip):
			skip = false
			dialogue_text.text = text
			break
	choices.show()

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


func _on_choice_b_pressed():
	_reset()
	ans = "b"

func _on_choice_a_pressed():
	_reset()
	ans = "a"
	
func read_json():
	_reset()
	show_text("A", "Lorem ipsum dolor sit amet. Et consequatur officia aut iure Quis qui quod harum id quasi unde! Et illum natus eos numquam fugit quo quod consectetur aut saepe repellat et quasi nemo et doloremque voluptatem. Aut rerum quod est natus soluta et eveniet atque sit facere esse cum illum labore. ")


