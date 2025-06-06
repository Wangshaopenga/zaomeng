extends State

var velocity := Vector2.ZERO


func enter(params := {}) -> void:
	player.animation_player.play("fall")


func update(delta: float) -> void:
	velocity = player.velocity

	if player.is_on_floor():
		player.reset_jumps()
		state_machine.change_state("Idle")

	elif Input.is_action_just_pressed("jump") and player.jump_count > 0:
		state_machine.change_state("Jump2")

	var dir := Input.get_axis("move_left", "move_right")
	if dir != 0:
		velocity.x = dir * player.RUN_SPEED
		player.change_dir(dir)
	else:
		velocity.x = 0

	player.velocity = velocity
