class_name BaseObject
extends CharacterBody2D

const GRAVITY := 980.0

var direction := 1:
	set(v):
		if v == 0:
			return
		direction = v
		if not is_node_ready():
			await ready
		graphics.scale.x = direction
var max_hp: int
var hp: int
var max_mp: int
var mp: int

@onready var graphics: Node2D = $Graphics
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine


func _ready():
	state_machine.change_state("Idle")


func _process(delta: float) -> void:
	state_machine.update(delta)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	move_and_slide()


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
