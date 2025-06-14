class_name BaseIdleState extends State


func enter(params := {}) -> void:
	player.change_anim("idle")
	player.velocity.x = 0


func update(delta: float) -> void:

	if player.velocity.y > 0:
		player.jump_count = 1
		state_machine.change_state("Fall")
		return

	# 检测输入切换到移动状态
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		#if player.is_on_floor():
		state_machine.change_state("Run")

	# 检测跳跃
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("Jump1")
		return

	player.atkInputEvent()
