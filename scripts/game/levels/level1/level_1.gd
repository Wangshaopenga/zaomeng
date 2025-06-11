extends Node2D


@onready var camera_2d: Camera2D = $Role/Camera2D

func _ready() -> void:
	camera_2d.reset_smoothing()
