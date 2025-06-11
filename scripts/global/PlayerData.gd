class_name PlayerDate extends Node

signal max_hp_changed ## 最大血量
signal max_mp_changed ## 最大蓝量
signal max_exp_changed ## 最大经验改变
signal hp_changed ## 血量改变触发
signal mp_changed ## 蓝量改变触发
signal exp_changed ## 经验改变触发
signal player_death ## 角色死亡
signal upgrade ## 升级
signal hp_regen_changed ## 生命恢复改变
signal mp_regen_changed ## 蓝量恢复改变

@export var max_hp := 100: ## 最大生命值
	set(v):
		max_hp = v
		max_hp_changed.emit()
@export var max_mp := 999: ## 最大体力值
	set(v):
		max_hp = v
		max_hp_changed.emit()
@export var max_exp := 100: ## 该等级最大经验值
	set(v):
		max_hp = v
		max_hp_changed.emit()
@export var grade := 22 ## 人物等级

@export var player_atk := 100 ## 玩家基础攻击力
@export var player_def := 0.0 ## 玩家免伤

@export var hp_regen := 3: ## 被动回血
	set(v):
		hp_regen = v
		hp_regen_changed.emit()
@export var mp_regen := 3: ## 被动回蓝
	set(v):
		mp_regen = v
		mp_regen_changed.emit()
@export var hp := max_hp: ## 当前生命值
	set(v):
		hp = clampi(v, 0, max_hp)
		hp_changed.emit()
		if hp == 0:
			player_death.emit()

@export var mp := max_mp: ## 当前体力值
	set(v):
		mp = clampi(v, 0, max_mp)
		mp_changed.emit()

@export var exp := 0: ## 经验值
	set(v):
		exp += v
		if v >= max_exp:
			grade += 1
			upgrade.emit()
			exp = clampi(exp - max_exp, 0, max_exp)
		exp_changed.emit()

var is_death = false ## 是否死亡

var atk_buff_temp = 0.0 #一次性攻击加成

#func _physics_process(delta: float) -> void:
	#if Engine.get_physics_frames() % 25 == 0:
		#useMp(1)


# 获取玩家伤害
func getDamage():
	if atk_buff_temp > 0:
		var new_atk = player_atk * (1 + atk_buff_temp / 100.0)
		atk_buff_temp = 0
		return roundi(new_atk)
	return roundi(player_atk)


# 回血
func health(_hp):
	if is_death:
		return
	hp = clampi(hp + _hp, 0, max_hp)
	hp_changed.emit(hp, max_hp)


# 减少或增加血量
func useHp(value):
	if is_death:
		return
	hp += value
	if hp <= 0:
		is_death = true
		player_death.emit()
	hp_changed.emit(hp, max_hp)


# 减少或增加体力
func useMp(value) -> bool:
	if value < 0:
		if mp >= abs(value):
			mp += value
			mp_changed.emit(mp, max_mp)
			return true
		else:
			return false
	else:
		hp = clampi(hp, 0, max_hp)
		mp_changed.emit(mp, max_mp)
		return true

# 使用对应能量
#func useMp():
	#pass
