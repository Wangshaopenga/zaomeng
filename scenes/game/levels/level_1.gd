extends Node2D

var cnt = 0

@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var test: TileMapLayer = $Test


func _ready() -> void:
	camera_2d.reset_smoothing()


#func _process(delta: float) -> void:
	#cnt += 1
	#if cnt ==300:
		#test.queue_free()
