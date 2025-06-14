class_name BaseJump2State extends State

var velocity = Vector2.ZERO # 水平和垂直速度


func enter(params := {}) -> void:
	player.change_anim("jump2")
	player.jump_count = 0


func update(delta: float) -> void:
	velocity = player.velocity

	velocity.y = player.JUMP_VELOCITY / 1.5

	if player.is_on_floor():
		player.reset_jumps()
		state_machine.change_state("Idle")

	if velocity.y > 0 or not player.animation_player.is_playing():
		state_machine.change_state("Fall")
		return

	player.velocity = velocity
