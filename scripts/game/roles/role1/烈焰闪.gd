extends State

#@export var dash_duration = 0.5 # Dash 持续时间

var trail_timer = 0

var cooldown = 2.0 # 冲刺冷却时间（秒）

# 内部变量
var cooldown_timer = 0 # 冷却计时器
var dash_direction # 冲刺方向


func preMethod():
	var skill = SkillUtils.getSkill('lys')
	if skill && PlayerData.useMp(-skill.mp):
		return true
	return false


func enter(params = {}):
	player.velocity.x = player.direction * player.RUN_SPEED * 3


	# 设置冲刺动画
	player.change_anim("烈焰闪", func finish():
		state_machine.change_state("Idle"))
	# 禁用冷却
	cooldown_timer = cooldown

#func update(delta):
	#player.velocity.x = lerp(player.velocity.x, dash_direction * player.RUN_SPEED * 2, 0.5)
	# 冷却计时更新
	#cooldown_timer = max(0.0, cooldown_timer - delta)
	#if cooldown_timer ==0:
	#print_debug(cooldown_timer)

	## 在 Dash 过程中定时生成残影
	#if trail_timer <= 0:
		#EffectUtils.create_trail({
			#"texture": player.anim_player.sprite_frames.get_frame_texture(player.anim_player.animation, player.anim_player.frame),
			#"global_position": player.global_position,
			#"offset": player.anim_player.position,
			#"transform": player.body.global_transform.x.x
			#})
		#trail_timer = trail_interval
