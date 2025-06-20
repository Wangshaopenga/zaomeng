class_name BaseHero
extends CharacterBody2D

signal on_player_move(_velocity)

const RUN_SPEED := 240.0
const JUMP_VELOCITY := -540.0
const GRAVITY := 980

@export var friction = 100 # 击退摩擦力
@export var atk_combo := false
# 人物朝向,-1:左  1:右 
@export var direction := 1:
	set(v):
		if v == 0:
			return
		direction = v
		if not is_node_ready():
			await ready
		## 因为照片默认向左所以取反
		graphics.scale.x = -v

var is_knocked_back = false # 是否处于击退状态
var jump_count := 2
var disable_gravity: bool = false

@onready var state_machine: StateMachine = $StateMachine
@onready var graphics: Node2D = $Graphics
@onready var jump_buffer_timer: Timer = $StateMachine/Jump1/JumpBufferTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var special_effect: Sprite2D = $Graphics/SpecialEffect
@onready var hit_box: Node2D = $Graphics/HitBox


func _ready() -> void:
	state_machine.change_state("Idle")


func _process(delta: float) -> void:
	if !is_knocked_back:
		state_machine.update(delta)


func _physics_process(delta: float) -> void:
	if is_knocked_back:
		# 添加摩擦力逐渐减速
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	else:
		on_player_move.emit(velocity)

	if not is_on_floor() and not disable_gravity:
		velocity.y += GRAVITY * delta
	else:
		if jump_buffer_timer.time_left > 0 and jump_count == 2:
			jump_buffer_timer.stop()
			state_machine.change_state("Jump1")
			return
	move_and_slide()


func change_anim(_name: String, callable = null) -> void:
	animation_player.play(_name)
	if animation_player.get_animation(_name).loop_mode == 0 && callable:
		await animation_player.animation_finished
		callable.call()


func reset_jumps() -> void:
	jump_count = 2


# 处理击退
func apply_knockback(knockback_force: Vector2, duration: float):
	if state_machine.current_state.name == 'Dash':
		return
	is_knocked_back = true
	velocity += knockback_force # 添加击退速度

	# 设置击退结束计时器
	await get_tree().create_timer(duration).timeout
	is_knocked_back = false # 结束击退状态
	velocity = Vector2.ZERO # 停止击退速度


func take_damage() -> int:
	print_debug("take damage")
	return 0
	#if state_machine.current_state.name == 'Parry':
		##Game.time_scale_frame(0.5,0.05)
		#state_machine.change_state("ParryAtk")
		#enemy.take_damage(10)
		##Game.knockback(self,enemy,120,-25)
		#return
	#if state_machine.current_state.name == 'Dash':
		##Game.time_scale_frame(0.2,0.3)
		#return
	#if state_machine.current_state.name == 'Block':
		#state_machine.current_state.doBlock(enemy)
	#else:
		#state_machine.change_state("Hit")
		#var last_damage = roundi(damage * (1 - PlayerData.player_def / 100.0))
		#PlayerData.useHp(-last_damage)
		##MessageBox.alert("受到伤害-%s" %last_damage)
		#print_debug("受到伤害-%s" %last_damage)


# 设置偏移
func setAnimOffset(offset):
	animation_player.offset = offset

	# 获取攻击范围

# 播放对应音效
#func playAudios(_name:String):
	#var audio = audios.get_node(_name)
	#if audio:
		#audio.play() 


# 检测当前范围目标
func checkHit(_name: String) -> Array:
	var enemies = []
	#var damage = combo_count * 10  # 假设每段伤害递增
	var attack_range = getAtkChecksArea(_name)
	if attack_range:
		for body in attack_range.get_overlapping_bodies():
			if body.is_in_group("Enemy"):
				enemies.append(body)
	return enemies


func getAtkChecksArea(_name: String):
	return hit_box.get_node(_name)


# 人物攻击和技能
func atkInputEvent() -> void:
	pass


## 敌人类待创建
class Enemy:
	extends Node
	var _name: String = "Enemy"
