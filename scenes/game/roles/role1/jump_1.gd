extends State

var velocity = Vector2.ZERO # 水平和垂直速度


func enter(params := {}) -> void:
	player.animation_player.play("jump1")
	player.jump_count -= 1


func update(delta: float) -> void:
	velocity = player.velocity
	
	if player.is_on_floor():
		velocity.y = player.JUMP1_VELOCITY

	if Input.is_action_just_pressed("jump") and player.jump_count > 0:
		state_machine.change_state("Jump2")

	if velocity.y > 0:
		state_machine.change_state("Fall")
		return

	var dir := Input.get_axis("move_left", "move_right")
	if dir != 0:
		velocity.x = dir * player.RUN_SPEED
		player.change_dir(dir)
	else:
		velocity.x = 0

	player.velocity = velocity
