class_name Player
extends Actor

# warning-ignore:unused_signal
signal collect_coin
#Zero
signal player_shoot
# warning-ignore:unused_signal
signal got_hurt
# warning-ignore:unused_signal
signal jump_attack

signal death

const FLOOR_DETECT_DISTANCE = 20.0

export(String) var action_suffix = ""

onready var platform_detector = $PlatformDetector
onready var animation_player = $AnimationPlayer
onready var shoot_timer = $ShootAnimation
onready var sprite = $Sprite
onready var sound_jump = $Jump
onready var gun = sprite.get_node(@"Gun")
onready var slider = $Fly
onready var sliderTimer = $SliderCooldown

onready var vfx_path = preload("res://Zero/Scene/Explosion.tscn")
onready var text_path = preload("res://Zero/Scene/Damage_Number.tscn")

onready var sprites = $Sprite  #Zero

onready var doubleJump = true  #Zero

onready var bufferTime = false  #Zero let player out of control and push back

onready var bufferTimeTrigger = false  #Zero

onready var jumpAttack = false  #Zero

onready var is_shooting = false

onready var is_sliding = false

onready var floating_time = 0;

onready var jumpY = global_position.y; # world postion 


func _ready():
	# Static types are necessary here to avoid warnings.
	var camera: Camera2D = $Camera
	if action_suffix == "_p1":
		camera.custom_viewport = $"../.."
		yield(get_tree(), "idle_frame")
		camera.make_current()
	elif action_suffix == "_p2":
		var viewport: Viewport = $"../../../../ViewportContainer2/Viewport2"
		viewport.world_2d = ($"../.." as Viewport).world_2d
		camera.custom_viewport = viewport
		yield(get_tree(), "idle_frame")
		camera.make_current()


#Zero
func _process(_delta):
	if is_sliding:
		reduce_stamina(_delta * 5)
		reset_fall()
		slider.show()
	else:
		slider.hide()

	if !is_sliding:
		recovery_stamina(clamp((Global.stamina / Global.max_stamina +0.1) * 10,1,10) * _delta)
	


# Physics process is a built-in loop in Godot.
# If you define _physics_process on a node, Godot will call it every frame.

# We use separate functions to calculate the direction and velocity to make this one easier to read.
# At a glance, you can see that the physics process loop:
# 1. Calculates the move direction.
# 2. Calculates the move velocity.
# 3. Moves the character.
# 4. Updates the sprite direction.
# 5. Shoots bullets.
# 6. Updates the animation.


# Splitting the physics process logic into functions not only makes it
# easier to read, it help to change or improve the code later on:
# - If you need to change a calculation, you can use Go To -> Function
#   (Ctrl Alt F) to quickly jump to the corresponding function.
# - If you split the character into a state machine or more advanced pattern,
#   you can easily move individual functions.
func _physics_process(_delta):
	
	if Global.playerHealth <= 0:
		death()

	#fall
	if(!is_on_floor()):
		floating_time += _delta
		jumpY = min(jumpY, global_position.y)

	if Global.stamina <= 0:
		_stop_sliding()
	# slide process
	if (
		Input.is_action_just_released("slide")
		and !is_on_floor()
		and !bufferTime
		and Global.stamina > 25
		and sliderTimer.is_stopped()
	):
		is_sliding = true
		_velocity.y = 0

	if is_sliding and Input.is_action_just_pressed("slide"):
		_stop_sliding()

	if is_sliding:
		vitual_gravity = gravity * 0.05
	else:
		vitual_gravity = gravity

	#audio
	# if (
	# 	(Input.is_action_just_pressed("jump" ) and is_on_floor() and !bufferTime)
	# 	or ((doubleJump and !bufferTime) and Input.is_action_just_pressed("jump" ))
	# ):
	# 	sound_jump.play()

	var direction = get_direction()
	if !is_sliding:
		# Jump process
		var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0  #is jumping
		_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	else:
		_velocity = calculate_move_velocity(_velocity, direction, speed, false)
	
	var snap_vector = Vector2.ZERO
	if direction.y == 0.0 and !bufferTime:
		snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
	var is_on_platform = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make Robi face left or right depending on the direction you move.
	if direction.x != 0 and !bufferTime:
		if direction.x > 0:
			sprite.scale.x = 1
			slider.scale.x = 1
		else:
			sprite.scale.x = -1
			slider.scale.x = -1

		#Zero Reset DoubleJump
	if is_on_floor():
		doubleJump = true
		_stop_sliding()
		if global_position.y - jumpY >  32 * 4.1:
			_fall_damage()
		reset_fall()

	_update_shoot()
	# apply hurt vfx
	_update_vfx(_delta)

	_update_Animation()


func _update_shoot():
	# We use the sprite's scale to store Robi’s look direction which allows us to shoot
	# bullets forward.
	# There are many situations like these where you can reuse existing properties instead of
	# creating new variables.

	if (
		Input.is_action_just_pressed("shoot")
		and shoot_timer.is_stopped()
		and Global.coins_collected > 0
	):  #Zero
		is_shooting = gun.shoot(sprite.scale.x)

		#Zero
		if is_shooting:
			Global.coins_collected -= 1
			emit_signal("player_shoot")
			shoot_timer.start()


func _update_Animation():
	var animation = get_new_animation(is_shooting)
	if animation != animation_player.current_animation:
		animation_player.play(animation)  #Animation update


func get_direction():
	if !bufferTime:
		if !jumpAttack:
			var y = 0

			if is_on_floor() and Input.is_action_just_pressed("jump"):
				# jumpY = global_position.y
				sound_jump.play()
				y = -1
			elif doubleJump and Input.is_action_just_pressed("jump"):
				sound_jump.play()
				doubleJump = false
				y = -0.9
			else:
				y = 0

			return Vector2(
				Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), y
			)  # Zero Double Jump
		else:
			jumpAttack = false
			sound_jump.play()
			return Vector2(sprite.scale.x, -1)
	else:
		if bufferTimeTrigger:  # jump once
			bufferTimeTrigger = false
			return Vector2(-sprite.scale.x, -0.7)
		else:
			return Vector2(-sprite.scale.x, 0)


# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(linear_velocity, direction, speed, is_jump_interrupted):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if is_sliding:
		velocity.x = speed.x * sprite.scale.x * 0.8
	if bufferTime:
		velocity.x *= 0.45
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
	return velocity


func get_new_animation(_is_shooting = false):
	var animation_new = ""
	if is_on_floor():
		if abs(_velocity.x) > 0.1:
			animation_new = "run"
		else:
			animation_new = "idle"
	else:
		if _velocity.y > 0:
			animation_new = "falling"
		else:
			animation_new = "jumping"
	if _is_shooting:
		animation_new += "_weapon"
	return animation_new


func _update_vfx(delta):
	if sprites.modulate.r < 1:
		sprites.modulate.r += 0.9 * delta
	if sprites.modulate.g < 1:
		sprites.modulate.g += 0.9 * delta
	if sprites.modulate.b < 1:
		sprites.modulate.b += 0.9 * delta


#Zero
func _on_Player_got_hurt(damage):
	if !bufferTime:
		apply_damage(damage)
		if Global.playerHealth > 0:
			bufferTime = true
			bufferTimeTrigger = true

			set_invincible_frame(2)
			yield(get_tree().create_timer(1.0), "timeout")
			bufferTime = false

func _fall_damage():
	var base_damage = clamp(floating_time * 2, 1, 100)
	apply_damage(base_damage  * base_damage)
	if Global.playerHealth > 0:
		set_invincible_frame(2)
		


func set_invincible_frame(time):
	set_collision_mask_bit(1, false)  # disable collider
	yield(get_tree().create_timer(time), "timeout")
	set_collision_mask_bit(1, true)  # enable collider


func _on_Player_jump_attack():
	reset_fall()
	jumpAttack = true
	_stop_sliding()


func get_vel():
	return _velocity


func apply_damage(damage):
	sprites.modulate = Color(1, 0.2, 0.2)
	Global.playerHealth = max(0, Global.playerHealth - damage)

	var damage_text = text_path.instance()
	
	add_child(damage_text)
	damage_text.global_position = global_position
	damage_text.set_number(damage)
	


func recovery_health(value):
	Global.playerHealth = min(Global.max_playerHealth, Global.playerHealth + value)


func recovery_all_health():
	recovery_health(100)


func recovery_stamina(value):
	Global.stamina = min(Global.max_stamina, Global.stamina + value)


func reduce_stamina(value):
	Global.stamina = max(0, Global.stamina - value)


func death():
	#reposition camera
	var camera = $Camera
	self.remove_child(camera)
	$"..".add_child(camera)
	camera.global_position = self.global_position

	var vfx = vfx_path.instance()
	$"..".add_child(vfx)
	vfx.global_position = self.global_position
	queue_free()


func _on_ShootAnimation_timeout():
	is_shooting = false


func _stop_sliding():
	is_sliding = false
	sliderTimer.start()

func reset_fall():
	jumpY = global_position.y
	floating_time = 0