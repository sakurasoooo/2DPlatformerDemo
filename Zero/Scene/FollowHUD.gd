extends Control
var stamina_overflow_time = 1

onready var stamina_canvas = self

onready var inner_stamina = $Control/StaminaInner

onready var outer_stamina = $Control/StaminaOuter

func _process(delta):
	if(Global.stamina >= Global.max_stamina):
		stamina_overflow_time -= delta
	else:
		stamina_overflow_time = 1

	stamina_canvas.modulate.a = max(0,stamina_overflow_time)

	if Global.max_stamina <= 100:
		inner_stamina.hide()
	else:
		inner_stamina.show()

	if Global.stamina < 25:
		inner_stamina.tint_progress = Color.red
		outer_stamina.tint_progress = Color.red
	elif Global.stamina < 0.5 * Global.max_stamina:
		inner_stamina.tint_progress = Color.yellow
		outer_stamina.tint_progress = Color.yellow
	else:
		inner_stamina.tint_progress = Color.green
		outer_stamina.tint_progress = Color.green

	outer_stamina.value = clamp(Global.stamina/100 * 100,0,100)
	inner_stamina.value = clamp((Global.stamina - 100)/100 * 100,0,100)
