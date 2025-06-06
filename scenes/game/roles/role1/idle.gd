extends State


func enter(params := {}) -> void:
	player.velocity.x = 0
	player.change_anim("idle")


func update(delta: float) -> void:
	# 检测输入切换到移动状态
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.change_state("Run")

	# 检测跳跃
	if Input.is_action_just_pressed("jump") :
			state_machine.change_state("Jump1")

	state_machine.atkInputEvent()
