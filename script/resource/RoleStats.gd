class_name RoleStats
extends Node

@export var max_hp: int = 3
@export var max_mp: int = 3
@export var max_experience: int = 3
@export var hp_regen: int = 0
@export var mp_regen: int = 0

var grade := 1

@onready var hp: int:
	set(v):
		hp = clampi(v, 0, max_hp)
@onready var mp: int:
	set(v):
		mp = clampi(v, 0, max_mp)
@onready var experience: int:
	set(v):
		experience = clampi(v, 0, max_experience)
