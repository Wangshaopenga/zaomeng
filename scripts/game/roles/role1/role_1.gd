extends BaseHero

# 技能所需消耗的时间的数据
@onready var skill_data = {
	"烈焰闪": { SkillStage.EXECUTE: 0.4 } ,
}


func _ready() -> void:
	state_machine.change_state("Idle")
	# 执行一个技能需要经过的几个阶段
	skill_actuator.set_stages([SkillStage.EXECUTE, SkillStage.COOLDOWN])
	# 添加技能
	skill_actuator.add_skill(SkillName.skill1, { SkillStage.COOLDOWN: 0, "mp": 100 })
	# 每个技能结束时，自动执行下一个
	skill_actuator.ended.connect(
		func(skill_name: StringName, tag: StringName):
		if skill_name in skill_data:
			_execute_next_skill()
	)


func _execute_next_skill() -> void:
	# 执行完了所有的小技能组，则此次技能执行完
	if _skill_queue.is_empty():
		return
	# 执行这组技能中的小块技能
	var skill_name = _skill_queue.pop_front()
	if not skill_actuator.has_skill(skill_name):
		skill_actuator.add_skill(skill_name)
		# 这个技能执行的时间线，对技能实现具体的执行细节
		var skill_node: TimeLine = skill_actuator.get_skill(skill_name)
		skill_node.executed_stage.connect(
			func(stage, data: Dictionary):
			# 播放动画
			if stage == SkillStage.EXECUTE:
				state_machine.change_state(skill_name)
			# 开始实现技能效果
			var duration = data.get(SkillStage.EXECUTE, 0)
			match skill_name:
				"烈焰闪":
					match stage:
							SkillStage.READY:
								print("ready")
							SkillStage.EXECUTE:
								print("execute")
								var skill_process = SkillProcess.new()
								skill_process.name = skill_name
								skill_process.duration = duration
								skill_process.callback = func():
									velocity.x = lerp(velocity.x, get_dir() * 800.0, 0.1)
							SkillStage.COOLDOWN:
								print("cooldown")
		)
	var execute_data: Dictionary = skill_data.get(skill_name) # 获取技能每个阶段执行完所需时间数据
	skill_actuator.execute(skill_name, execute_data) # 执行


## 执行技能组的名称
func execute_skill(skill_name: String):
	if not state_machine.is_skill_running:
		if skill_actuator.is_can_execute(skill_name):
			skill_actuator.execute(skill_name)
			# 切换到执行技能状态
			state_machine.is_skill_running = true
			#state_node.trans_to_child(StateName.SKILL)
			# 这个技能执行具体效果的小技能组
			match skill_name:
				SkillName.skill1:
					_skill_queue.append("烈焰闪")
					#_skill_queue.append("烈焰闪_循环")
					#_skill_queue.append("烈焰闪_结束")
			# 开始执行小技能组
			_execute_next_skill()
		else:
			print_debug(skill_name, " 技能正在冷却中，剩余时间：", skill_actuator.get_skill(skill_name).get_time_left())
