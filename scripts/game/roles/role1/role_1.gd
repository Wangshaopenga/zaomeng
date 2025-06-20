extends BaseHero


func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	print_debug("player has been hurt")


func take_damage() -> int:
	var current_state = state_machine.current_state
	print_debug(current_state.attack_index)
	return 1


func atkInputEvent(params := {}):
	if Input.is_action_just_pressed("attack"):
		state_machine.change_state("Attack", { "attack_index": params.get("attack_index", 1) })
	if Input.is_action_just_pressed("l"):
		state_machine.change_state("烈焰闪")
	if Input.is_action_just_pressed("i"):
		state_machine.change_state("重斩")
