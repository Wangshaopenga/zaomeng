class_name BaseAttackState extends State

# 能否进行下段攻击
var next_attack_requested := false

# 当前处于第几段攻击
var attack_index := 1

# 是否在空中攻击
var is_air_attack := false


func enter(params := {}) -> void:
	next_attack_requested = false
	is_air_attack = not player.is_on_floor()
	attack_index = params.get("attack_index", 1)
	if is_air_attack:
		attack_index = 2
	else:
		player.velocity.x = 0
	player.change_anim("attack%d" % attack_index, finish)


func update(delta: float) -> void:
	# 地面攻击时持续锁定水平速度
	if not is_air_attack:
		player.velocity.x = 0

	if Input.is_action_just_pressed("jump") and player.jump_count > 0:
		if player.jump_count == 2:
			state_machine.change_state("Jump1")
		else:
			state_machine.change_state("Jump2")
		return

	# 玩家尝试连击（地面状态下）
	if Input.is_action_just_pressed("attack") and player.atk_combo and not is_air_attack:
		next_attack_requested = true



# 可以打断攻击,减少僵直,如果不想可以把上面jump判断移动到动画播放完之后
func exit():
	player.special_effect.visible = false


func finish():
	if is_air_attack:
		state_machine.change_state("Fall")
		return
	if not next_attack_requested or attack_index == 4:
		state_machine.change_state("Idle")
		return
	state_machine.change_state("Attack", { "attack_index": attack_index + 1 })

func attack():
	print_debug("atk")
