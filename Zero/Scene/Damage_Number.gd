extends RigidBody2D

onready var numberLabel = $Label

func set_number(value):
	var scale_ratio = clamp(value/100, 0.5,1.5)
	scale = scale_ratio * Vector2.ONE
	numberLabel.text = str(int(value))

func _ready():
	apply_central_impulse(Vector2.UP * 200)
	yield(get_tree().create_timer(1), "timeout")
	queue_free()

