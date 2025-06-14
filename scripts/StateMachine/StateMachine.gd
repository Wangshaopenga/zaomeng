class_name StateMachine
extends Node

# 状态字典
var states := {}
var current_state: State
var player: BaseHero


func _ready() -> void:
	player = get_parent()
	for state in get_children():
		add_state(state.name, state)


func add_state(state_name: String, state: State) -> void:
	states[state_name] = state
	state.init(self, player)


func get_state(state_name: String) -> State:
	return states[state_name]


func change_state(state_name: String, params = {}) -> void:
	var pre_state: State = states.get(state_name)
	if not pre_state.preMethod():
		return
	if current_state:
		#print_debug(current_state.name + "=>" + state_name)
		current_state.exit()
	current_state = pre_state
	if current_state:
		current_state.enter(params)
	else:
		print("State not found", state_name)


# 更新当前状态
func update(delta):
	if current_state:
		current_state.update(delta)
