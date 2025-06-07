extends State

var velocity = Vector2.ZERO # 水平和垂直速度


func enter(params := {}) -> void:
	player.change_anim( "jump1")
	player.jump_count = 1
	player.velocity.y = player.JUMP_VELOCITY


func update(delta: float) -> void:
	velocity = player.velocity

	if Input.is_action_just_pressed("jump") and player.jump_count > 0:
		state_machine.change_state("Jump2")
		return

	if velocity.y > 0:
		state_machine.change_state("Fall")
		return

	var dir := Input.get_axis("move_left", "move_right")
	player.direction = dir
	if dir != 0:
		velocity.x = dir * player.RUN_SPEED
	else:
		velocity.x = 0

	player.velocity = velocity

	state_machine.atkInputEvent()
