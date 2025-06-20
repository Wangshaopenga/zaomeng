extends State


func preMethod():
	var skill = SkillUtils.getSkill('zz')
	if skill && PlayerData.useMp(-skill.mp):
		return true
	return false


func enter(params = {}):
	player.velocity = Vector2.ZERO
	player.disable_gravity = true  # 禁用重力
	
	# 设置冲刺动画
	player.change_anim("重斩", func finish():
		player.disable_gravity = false  # 动画结束后恢复重力
		state_machine.change_state("Idle"))
