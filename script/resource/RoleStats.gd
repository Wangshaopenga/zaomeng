class_name RoleStats
extends Node

@export var max_hp := 3
@export var max_mp := 3
@export var max_experience := 100


var grade := 1

@onready var hp := max_hp:
	set(v):
		hp = clampi(v, 0, max_hp)
@onready var mp := max_mp:
	set(v):
		mp = clampi(v, 0, max_mp)
@onready var experience := max_experience:
	set(v):
		experience = clampi(v, 0, max_experience)
