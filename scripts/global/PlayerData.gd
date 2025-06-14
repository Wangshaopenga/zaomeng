extends Node

# 血量改变触发
signal on_hp_changed(current, max)

# 体力改变触发
signal on_mp_changed(current, max)

# 经验改变触发
signal on_exp_changed(current)

# 角色死亡
signal on_player_death()

@export var max_hp = 100 ## 最大生命值
@export var current_hp = 100 ## 当前生命值
@export var hp_regen = 1 ## 被动回血
@export var max_mp = 9900 ## 最大体力值
@export var current_mp = 9900 ## 当前体力值
@export var mp_regen = 1 ## 被动回蓝
@export var exp = 999 ## 经验
@export var max_exp = 999 ## 经验
@export var grade = 1 ## 等级

@export var player_atk = 100 # 玩家基础攻击力
@export var player_def = 0.0 # 玩家免伤

var is_death = false ## 是否死亡

var atk_buff_temp = 0.0 #一次性攻击加成


# 获取玩家伤害
func getDamage():
	if atk_buff_temp > 0:
		var new_atk = player_atk * (1 + atk_buff_temp / 100.0)
		atk_buff_temp = 0
		return roundi(new_atk)
	return roundi(player_atk)

#func _physics_process(delta: float) -> void:
	#if Engine.get_physics_frames() % 25 == 0:


# 减少或增加血量
func useHp(value):
	if is_death:
		return
	current_hp = clamp(current_hp + value, 0, max_hp)
	if current_hp <= 0:
		is_death = true
		on_player_death.emit()
	on_hp_changed.emit(current_hp, max_hp)


# 减少或增加体力
func useMp(value) -> bool:
	if value < 0:
		if current_mp >= abs(value):
			current_mp += value
			on_mp_changed.emit(current_mp, max_mp)
			return true
		else:
			print_debug("体力不足")
			#MessageBox.alert("体力不足！")
			return false
	else:
		current_mp = clamp(current_mp + value, 0, max_mp)
		on_mp_changed.emit(current_mp, max_mp)
		return true


# 增加经验
func useExp(value):
	if exp + value > max_exp:
		exp += value - max_exp
		print_debug("升级!!!功能待实现")
	else:
		exp += value
	on_exp_changed.emit(exp, max_exp)
