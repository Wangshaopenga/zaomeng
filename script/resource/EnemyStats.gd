class_name EnemyStats
extends Node

@export var max_hp := 3

@onready var hp := max_hp:
	set(v):
		v = clampi(v, 0, max_hp)
		if v != hp:
			hp = v
