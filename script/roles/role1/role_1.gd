extends BaseHero


func atkInputEvent(params := {}):
	if Input.is_action_just_pressed("attack"):
		var attack_index = params.get("attack_index", 1)
		state_machine.change_state("Attack", { "attack_index": attack_index })
