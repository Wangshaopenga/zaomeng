extends Node

signal on_skill_click(skill: Skill)
signal on_skill_upgrade(skill: Skill) # 天赋升级

enum UpgradeStatus {
	SUCCESS,
	# 成功
	NO_PRE,
	# 缺少前置
	MAX_LEVEL # 等级已满,
}

var player_skills = {
	
} # 玩家持有天赋


# 获取天赋
func getSkill(id) -> Skill:
	if player_skills.has(id):
		return player_skills.get(id)
	return null


# 升级天赋
func upgradeSkill(_skill: Skill) -> UpgradeStatus:
	if _skill.prerequisites.size() > 0:
		for pre in _skill.prerequisites:
			if not player_skills.has(pre.id):
				#MessageBox.alert("缺少前置天赋："+pre.name)
				print_debug("缺少前置天赋：" + pre.name)
				return UpgradeStatus.NO_PRE

	var skill: Skill = player_skills.get(_skill.id)
	if skill:
		if skill.current_level < skill.max_level:
			skill.current_level += 1
			on_skill_upgrade.emit(skill)
			#MessageBox.alert("天赋[%s]提升至Lv%s" % [skill.name, skill.current_level])
			print_debug("天赋[%s]提升至Lv%s" % [skill.name, skill.current_level])
			return UpgradeStatus.SUCCESS
		else:
			#MessageBox.alert("天赋已达到最大等级：" + skill.name)
			print_debug("天赋已达到最大等级：" + skill.name)
			return UpgradeStatus.MAX_LEVEL
	else:
		player_skills[_skill.id] = _skill
		player_skills[_skill.id].current_level += 1
		on_skill_upgrade.emit(player_skills[_skill.id])
		#MessageBox.alert("已学习天赋：" + player_skills[_skill.id].name)
		print_debug("已学习天赋：" + player_skills[_skill.id].name)
		return UpgradeStatus.SUCCESS
