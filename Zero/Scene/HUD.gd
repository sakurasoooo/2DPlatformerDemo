extends Control
onready var healthMonitor = $CanvasLayer/HealthBar/AnimatedSprite


func _process(delta):
	UpdateHealth()

	if(Global.playerHealth <= 0):
		healthMonitor.play("death")
	else:
		healthMonitor.play("default")


func UpdateHealth():
	healthMonitor.modulate.h = (((Global.playerHealth) / 100.0 * 108.0) / 360.0)
