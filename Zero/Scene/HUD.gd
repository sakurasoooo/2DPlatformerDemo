extends Control
onready var healthMonitor = $CanvasLayer/HealthBar/AnimatedSprite
onready var health_recovery_icon = $CanvasLayer/Sprite
onready var health_text = $CanvasLayer/Label
func _ready():
	health_recovery_icon.hide()
	health_text.hide()

func _process(_delta):
	UpdateHealth()

	if(Global.playerHealth <= 0):
		healthMonitor.play("death")
	else:
		healthMonitor.play("default")

	if(Global.healSkill):
		health_recovery_icon.show()

	health_text.text = str(int(Global.playerHealth)) + "/100"


func UpdateHealth():
	healthMonitor.modulate.h = (((Global.playerHealth) / 100.0 * 108.0) / 360.0)



func _on_HealthBar_mouse_exited():
	health_text.hide()

func _on_HealthBar_mouse_entered():
	health_text.show()
