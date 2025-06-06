class_name Player
extends CharacterBody2D

const RUN_SPEED := 360.0
const JUMP1_VELOCITY := -540.0
const JUMP2_VELOCITY := -840.0
const GRAVITY := 980

# 人物朝向,1:右 -1:左
var direction := 1
var jump_count := 2

@onready var state_machine: StateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var graphics: Node2D = $Graphics


func _ready() -> void:
	state_machine.change_state("Idle")


func _process(delta: float) -> void:
	state_machine.update(delta)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	move_and_slide()


func change_anim(_name, callback = null) -> void:
	animation_player.play(_name)
	if not animation_player.get_animation(_name).loop_mode && callback:
		await animation_player.animation_finished
		callback.call()


func change_dir(dir: float) -> void:
	graphics.scale.x = dir


func reset_jumps() -> void:
	jump_count = 2
