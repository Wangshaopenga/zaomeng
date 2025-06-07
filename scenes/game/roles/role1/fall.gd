extends State

var velocity := Vector2.ZERO


func enter(params := {}) -> void:
	player.change_anim("fall")


func update(delta: float) -> void:
	velocity = player.velocity

	if player.is_on_floor():
		player.reset_jumps()
		state_machine.change_state("Idle")
		return

	if Input.is_action_just_pressed("jump"):
		if player.jump_count > 0:
			if player.jump_count == 2:
				state_machine.change_state("Jump1")
				return
			elif player.jump_count == 1:
				state_machine.change_state("Jump2")
				return
		elif player.jump_buffer_timer.is_stopped():
			player.jump_buffer_timer.start()

	var dir := Input.get_axis("move_left", "move_right")
	player.direction = dir
	if dir != 0:
		velocity.x = dir * player.RUN_SPEED
	else:
		velocity.x = 0

	player.velocity = velocity

	state_machine.atkInputEvent({ "attack_index": 2 })
