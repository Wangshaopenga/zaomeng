class_name BaseFallState extends State

var velocity := Vector2.ZERO


func enter(params := {}) -> void:
	player.change_anim("fall")


func update(delta: float) -> void:
	velocity = player.velocity

	if Input.is_action_just_pressed("jump"):
		print_debug(player.jump_count)
		if player.jump_count > 0:
			if player.jump_count == 2:
				state_machine.change_state("Jump1")
				return
			elif player.jump_count == 1:
				state_machine.change_state("Jump2")
				return
		elif player.jump_buffer_timer.is_stopped():
			player.jump_buffer_timer.start()

	var new_dir = 0
	if Input.is_action_pressed("move_left"):
		new_dir = -1
	elif Input.is_action_pressed("move_right"):
		new_dir = 1

	if new_dir != 0:
		player.direction = new_dir
		velocity.x = lerp(velocity.x, new_dir * player.RUN_SPEED, 0.5)

	if player.is_on_floor():
		player.reset_jumps()
		state_machine.change_state("Idle")
		return

	player.velocity = velocity

	player.atkInputEvent()
