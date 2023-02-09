extends Control

func _ready():
	hide()

func _process(_delta):
	if(Global.playerHealth <=0):
		show()
	else:
		hide()