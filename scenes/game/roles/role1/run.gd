extends State

var velocity = Vector2.ZERO # 水平和垂直速度


func enter(params = {}) -> void:
	player.change_anim("run")


func update(delta: float) -> void:
	velocity = player.velocity
	var dir = Input.get_axis("move_left", "move_right")
	if dir != 0:
		velocity.x = dir * player.RUN_SPEED
		player.change_dir(dir)
	else:
		velocity.x = 0
		if player.is_on_floor():
			state_machine.change_state("Idle")

	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("Jump1")

	player.velocity = velocity
