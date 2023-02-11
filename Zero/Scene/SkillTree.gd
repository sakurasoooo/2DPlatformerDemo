extends Control

export(Vector2) var _start_position = Vector2(0, -20)
export(Vector2) var _end_position = Vector2.ZERO
export(float) var fade_in_duration = 0.3
export(float) var fade_out_duration = 0.2

onready var healSkill = $NinePatchRect/Heal
onready var sliderSkill = $NinePatchRect/Slide
onready var jumpSkill = $NinePatchRect/Double
onready var gunSkill = $NinePatchRect/Gun
onready var doubleCoin = $NinePatchRect/DoubleCoin
onready var trippleCoin = $NinePatchRect/TripleCoin
onready var moreStanima = $NinePatchRect/StanimaA
onready var moremoreStanima = $NinePatchRect/StanimaB

onready var tween = $Tween

onready var back_button = $NinePatchRect/BackButton

onready var healSkillPrice = 10
onready var sliderSkillPrice = 30
onready var jumpSkillPrice = 15
onready var gunSkillPrice = 15
onready var doubleCoinPrice = 50
onready var trippleCoinPrice = 100
onready var moreStanimaPrice = 30
onready var moremoreStanimaPrice = 100


func _ready():
	hide()
	healSkill._set_price(healSkillPrice)
	sliderSkill._set_price(sliderSkillPrice)
	jumpSkill._set_price(jumpSkillPrice)
	gunSkill._set_price(gunSkillPrice)
	doubleCoin._set_price(doubleCoinPrice)
	trippleCoin._set_price(trippleCoinPrice)
	moreStanima._set_price(moreStanimaPrice)
	moremoreStanima._set_price(moremoreStanimaPrice)


func _input(_event):
	if Global.unlockLevel >= 0:
		healSkill._unlock()
	if Global.unlockLevel >= 1:
		if healSkill.activated():
			gunSkill._unlock()
	if Global.unlockLevel >= 2:
		if gunSkill.activated():
			jumpSkill._unlock()
			doubleCoin._unlock()
	if Global.unlockLevel >= 3:
		if jumpSkill.activated():
			sliderSkill._unlock()
		if doubleCoin.activated():
			trippleCoin._unlock()
	if Global.unlockLevel >= 4:
		if sliderSkill.activated():
			moreStanima._unlock()
	if Global.unlockLevel >= 5:
		if moreStanima.activated():
			moremoreStanima._unlock()


func _on_BackButton_pressed():
	_close()


func _open():
	show()
	back_button.grab_focus()
	tween.interpolate_property(
		self, "modulate:a", 0.0, 1.0, fade_in_duration, Tween.TRANS_LINEAR, Tween.EASE_IN
	)

	tween.start()


func _close():
	tween.interpolate_property(
		self, "modulate:a", 1.0, 0.0, fade_out_duration, Tween.TRANS_LINEAR, Tween.EASE_IN
	)

	tween.start()


func _on_Tween_tween_all_completed():
	if modulate.a < 0.5:
		hide()


func _unhandled_input(event):
	if event.is_action_pressed("toggle_pause") and visible:
		_close()
		get_tree().set_input_as_handled()


func _on_healSkillButton_pressed():
	if healSkillPrice <= Global.coins_collected:
		Global.coins_collected -= healSkillPrice
		healSkill.set_actived()
		Global.emit_signal("healSkill")
		Global.healSkill = true
		Global.unlockLevel = int(max(Global.unlockLevel,1))
	else:
		healSkill._deselect()


func _on_sliderSkillButton_pressed():
	if sliderSkillPrice <= Global.coins_collected:
		Global.coins_collected -= sliderSkillPrice
		sliderSkill.set_actived()
		Global.emit_signal("sliderSkill")
		Global.sliderSkill = true
		Global.unlockLevel = int(max(Global.unlockLevel,4))
	else:
		sliderSkill._deselect()


func _on_jumpSkillButton_pressed():
	if jumpSkillPrice <= Global.coins_collected:
		Global.coins_collected -= jumpSkillPrice
		jumpSkill.set_actived()
		Global.emit_signal("jumpSkill")
		Global.doubleJumpSkill = true
		Global.unlockLevel = int(max(Global.unlockLevel,3))
	else:
		jumpSkill._deselect()


func _on_gunSkillButton_pressed():
	if gunSkillPrice <= Global.coins_collected:
		Global.coins_collected -= gunSkillPrice
		gunSkill.set_actived()
		Global.emit_signal("gunSkill")
		Global.gunSkill = true
		Global.unlockLevel = int(max(Global.unlockLevel,2))
	else:
		gunSkill._deselect()


func _on_doubleCoinButton_pressed():
	if doubleCoinPrice <= Global.coins_collected:
		Global.coins_collected -= doubleCoinPrice
		doubleCoin.set_actived()
		Global.emit_signal("doubleCoin")
		Global.moreCoinSkill = true
		Global.unlockLevel = int(max(Global.unlockLevel,3))
	else:
		doubleCoin._deselect()


func _on_trippleCoinButton_pressed():
	if trippleCoinPrice <= Global.coins_collected:
		Global.coins_collected -= trippleCoinPrice
		trippleCoin.set_actived()
		Global.emit_signal("trippleCoin")
		Global.moremoreCoinSkill = true
		Global.unlockLevel = int(max(Global.unlockLevel,4))
	else:
		trippleCoin._deselect()


func _on_moreStanimaButton_pressed():
	if moreStanimaPrice <= Global.coins_collected:
		Global.coins_collected -= moreStanimaPrice
		moreStanima.set_actived()
		Global.emit_signal("moreStanima")
		Global.moreStanimaSkill= true
		Global.unlockLevel = int(max(Global.unlockLevel,5))
	else:
		moreStanima._deselect()

func _on_moremoreStanimaButton_pressed():
	if moremoreStanimaPrice <= Global.coins_collected:
		Global.coins_collected -= moremoreStanimaPrice
		moremoreStanima.set_actived()
		Global.emit_signal("moremoreStanima")
		Global.moremoreStanimaSkill= true
		Global.unlockLevel = int(max(Global.unlockLevel,6))
	else:
		moremoreStanima._deselect()
