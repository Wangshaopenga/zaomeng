extends State

var velocity = Vector2.ZERO # 水平和垂直速度


func enter(params = {}) -> void:
	player.change_anim("run")


func update(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and player.jump_count > 0:
		state_machine.change_state("Jump1")
		return

	state_machine.atkInputEvent()

	if player.velocity.y > 0:
		state_machine.change_state("Fall")
		return

	velocity = player.velocity
	var dir = Input.get_axis("move_left", "move_right")
	player.change_dir(dir)

	if dir != 0:
		velocity.x = dir * player.RUN_SPEED
	else:
		velocity.x = 0
		if player.is_on_floor():
			state_machine.change_state("Idle")
	player.velocity = velocity
