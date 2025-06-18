class_name BaseRunState extends State

var velocity = Vector2.ZERO # 水平和垂直速度


func enter(params = {}) -> void:
	player.change_anim("run")


func update(delta: float) -> void:
	if player.is_on_floor():
		player.jump_count = 2
	
	velocity = player.velocity

	if player.velocity.y > 0:
		state_machine.change_state("Fall")
		return

	var new_dir = 0 # 检测输入方向
	# 检测左右移动
	if Input.is_action_pressed("move_left"):
		new_dir = -1
	elif Input.is_action_pressed("move_right"):
		new_dir = 1
	if new_dir != 0:
		player.direction = new_dir
		velocity.x = lerp(velocity.x, new_dir * player.RUN_SPEED, 0.5)
	else:
		if player.is_on_floor():
			state_machine.change_state("Idle")
	player.velocity = velocity

	if Input.is_action_just_pressed("jump"):
		print_debug(player.jump_count)

		if player.jump_count > 0:
			state_machine.change_state("Jump1")
		return

	player.atkInputEvent()


func exit() -> void:
	velocity.x = 0
