extends NinePatchRect

onready var narrator_name = $Dialog/Name

func set_name(_name):
	narrator_name.text = _name