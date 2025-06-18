class_name BaseJump1State extends State

var velocity = Vector2.ZERO # 水平和垂直速度


func enter(params := {}) -> void:
	player.change_anim("jump1")
	player.jump_count = 1
	#player.velocity.y = player.JUMP_VELOCITY


func update(delta: float) -> void:
	velocity = player.velocity
	if player.is_on_floor():
		velocity.y = player.JUMP_VELOCITY

	if Input.is_action_just_pressed("jump"):
		print_debug(player.jump_count)

		if player.jump_count > 0:
			state_machine.change_state("Jump2")
		return

	if velocity.y > 0:
		state_machine.change_state("Fall")
		return

	var new_dir = 0
	if Input.is_action_pressed("move_left"):
		new_dir = -1
	elif Input.is_action_pressed("move_right"):
		new_dir = 1
	if new_dir != 0:
		player.direction = new_dir
		velocity.x = lerp(velocity.x, new_dir * player.RUN_SPEED, 0.5)
	else:
		velocity.x = 0
	player.velocity = velocity

	player.atkInputEvent()
