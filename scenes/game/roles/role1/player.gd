class_name Player
extends CharacterBody2D

const RUN_SPEED := 240.0
const JUMP_VELOCITY := -540.0
const GRAVITY := 980

# 人物朝向,1:右 -1:左
var direction := 1:
	set(v):
		if v == 0:
			return
		direction = v
		if not is_node_ready():
			await ready
		graphics.scale.x = direction

var jump_count := 2

@onready var state_machine: StateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var graphics: Node2D = $Graphics
@onready var jump_buffer_timer: Timer = $JumpBufferTimer


func _ready() -> void:
	state_machine.change_state("Idle")


func _process(delta: float) -> void:
	state_machine.update(delta)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		if jump_buffer_timer.time_left > 0 and jump_count == 2:
			print(2)
			jump_buffer_timer.stop()
			state_machine.change_state("Jump1")
			return
	move_and_slide()



func change_anim(_name, callback = null) -> void:
	animation_player.play(_name)
	if not animation_player.get_animation(_name).loop_mode && callback:
		await animation_player.animation_finished
		callback.call()


func reset_jumps() -> void:
	jump_count = 2
