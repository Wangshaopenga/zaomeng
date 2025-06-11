extends State


func enter(params := {}) -> void:
	state_machine.is_skill_running = true
	player.change_anim("烈焰闪", "skill")


func update(delta: float) -> void:
	if not player.animation_player.is_playing():
		state_machine.change_state("Idle")


func exit():
	player.velocity.x = 0
	state_machine.is_skill_running = false
