extends BaseHero


func atkInputEvent(params := {}):
	if Input.is_action_just_pressed("attack"):
		state_machine.change_state("Attack", { "attack_index": params.get("attack_index", 1) })
	if Input.is_action_just_pressed("l"):
		state_machine.change_state("烈焰闪")
