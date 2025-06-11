class_name BaseHero
extends CharacterBody2D

enum Direction {
	LEFT = -1,
	RIGHT = 1,
}

const RUN_SPEED := 240.0
const JUMP_VELOCITY := -540.0
const GRAVITY := 980

@export var atk_combo := false
# 人物朝向,-1:左  1:右 
@export var direction := Direction.RIGHT:
	set(v):
		direction = v
		if not is_node_ready():
			await ready
		graphics.scale.x = v

var jump_count := 2
var _skill_queue: Array = []

@onready var state_machine: StateMachine = $StateMachine
@onready var graphics: Node2D = $Graphics
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var special_effect: Sprite2D = $Graphics/SpecialEffect
@onready var skill_actuator: SkillActuator = $SkillActuator
# 技能所需消耗的时间的数据
@onready var skill_data = {
	"烈焰闪": { SkillStage.EXECUTE: 0.4 } ,
	#"烈焰闪_循环": { SkillStage.EXECUTE: 0.4 } ,
	#"烈焰闪_结束": { SkillStage.EXECUTE: 0 }
	#"剑_螺旋刺": { SkillStage.EXECUTE: _get_sprite_frame_time("剑_螺旋刺"), },
	#"剑_螺旋刺_循环": {SkillStage.EXECUTE: 0.5, },
	#"剑_螺旋刺_结束": {SkillStage.EXECUTE: _get_sprite_frame_time("剑_螺旋刺_结束"), },
}


func _ready() -> void:
	state_machine.change_state("Idle")
	# 执行一个技能需要经过的几个阶段
	skill_actuator.set_stages([SkillStage.READY, SkillStage.EXECUTE, SkillStage.COOLDOWN])
	# 添加技能
	skill_actuator.add_skill(SkillName.skill1, { SkillStage.COOLDOWN: 1, "mp": 100 })

	# 每个技能结束时，自动执行下一个
	skill_actuator.ended.connect(
		func(skill_name: StringName, tag: StringName):
		if skill_name in skill_data:
			_execute_next_skill()
	)


func _process(delta: float) -> void:
	state_machine.update(delta)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		if jump_buffer_timer.time_left > 0 and jump_count == 2:
			jump_buffer_timer.stop()
			state_machine.change_state("Jump1")
			return
	move_and_slide()


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
			print(data)
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
								var direction = 400 * get_dir()
								skill_process.callback = func():
									velocity.x = direction
									move_and_slide()
							SkillStage.COOLDOWN:
								velocity.x = 0
								print("cooldown")

		)
	var data: Dictionary = skill_data.get(skill_name) # 获取技能每个阶段执行完所需时间数据
	skill_actuator.execute(skill_name, data) # 执行


func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	print("player has been hurt")


func change_anim(_name: String, library: String = "", callback = null) -> void:
	var anima
	if not library.is_empty():
		animation_player.play(library + "/" + _name)
		anima = animation_player.get_animation_library(library).get_animation(_name)
	else:
		animation_player.play(_name)
		anima = animation_player.get_animation(_name)
	if anima.loop_mode && callback:
		await animation_player.animation_finished
		callback.call()


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


func reset_jumps() -> void:
	jump_count = 2


func change_dir(dir: int) -> void:
	if dir == 0:
		return
	if dir == 1:
		direction = Direction.RIGHT
	elif dir == -1:
		direction = Direction.LEFT


func get_dir() -> int:
	if direction == Direction.RIGHT:
		return 1
	return - 1


# 技能线程
class SkillProcess:
	extends Node

	var callback: Callable
	var duration: float
	var _time = 0

	func _init() -> void:
		Engine.get_main_loop().current_scene.add_child(self, true)

	func _process(delta: float) -> void:
		callback.call()
		_time += delta
		if _time >= duration:
			queue_free()
			return
