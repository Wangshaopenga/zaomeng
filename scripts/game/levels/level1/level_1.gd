extends Node2D

@onready var camera_2d: Camera2D = $Role/Camera2D
@onready var effect_nodes: Node2D = $EffectNodes


func _ready() -> void:
	camera_2d.reset_smoothing()
