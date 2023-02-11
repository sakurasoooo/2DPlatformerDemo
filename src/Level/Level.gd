extends Node2D

const LIMIT_LEFT = -315
const LIMIT_TOP = -250
const LIMIT_RIGHT = 955
const LIMIT_BOTTOM = 690

onready var dialogue = $"/root/Game/Dialogue"

onready var player = $Player

func _ready():
	# for child in get_children():
	# 	if child is Player:
	# 		var camera = child.get_node("Camera")
	# 		camera.limit_left = LIMIT_LEFT
	# 		camera.limit_top = LIMIT_TOP
	# 		camera.limit_right = LIMIT_RIGHT
	# 		camera.limit_bottom = LIMIT_BOTTOM
	
	yield(get_tree().create_timer(1),"timeout") # wait game initialization
	get_tree().paused = true
	print(dialogue.name)
	dialogue._reset()
	dialogue.set_character("A","Author")
	dialogue.set_text("Welcome to the Geyvat. Choose your gift")
	dialogue.set_choice("A","Treasure")
	dialogue.set_choice("B","Be Stronger")
	dialogue.set_choice("C","Nothing")
	yield(dialogue.show_dialog(),"completed")
	var choice = (dialogue.ans)
	if(choice == "a"):
		Global.coins_collected += 50
	elif (choice == "b"):
		Global.max_playerHealth = 200
		Global.playerHealth = 200
	
	yield(get_tree().create_timer(1),"timeout")
	dialogue._reset()
	dialogue.set_character("B","Sound of Mystery")
	dialogue.set_text("LEAVING HERE !!!! LEAVING HERE !!!! LEAVING HERE !!!!")
	dialogue.set_choice("A","Ignore him")
	yield(dialogue.show_dialog(),"completed")

	get_tree().paused = false

# func _input(_event):
# 	if	_event.is_action_pressed("toggle_pause"):
# 		get_tree().set_input_as_handled()

