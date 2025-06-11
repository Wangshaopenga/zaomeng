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


func _ready() -> void:
	state_machine.change_state("Idle")


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


func reset_jumps() -> void:
	jump_count = 2


func change_dir(dir: float) -> void:
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
