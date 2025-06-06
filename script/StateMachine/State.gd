class_name State
extends Node

var state_machine :StateMachine
var player: Player

func init(_state_machine:StateMachine,_player:Player)->void:
	state_machine = _state_machine
	player = _player

func enter(params := {})->void:
	pass
func update(delta:float)->void:
	pass
func exit()->void:
	pass
func preMethod() -> bool:
	return true
