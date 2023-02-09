extends Sprite

onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("Explosion")

func _death():
	queue_free()