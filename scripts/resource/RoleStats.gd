#class_name RoleStats
#extends Node
#
#signal hp_change
#signal mp_change
#
#@export var max_hp: int = 3
#@export var max_mp := 3
#@export var max_exp := 3
#@export var hp_regen := 0
#@export var mp_regen := 0
#
#var grade := 1
#
#@onready var hp := 1000:
	#set(v):
		#hp = clampi(v, 0, max_hp)
		#hp_change.emit()
		#hp_change.emit()
#@onready var mp := max_mp:
	#set(v):
		#mp = clampi(v, 0, max_mp)
		#mp_change.emit()
#@onready var exp := 0:
	#set(v):
		#exp = clampi(v, 0, max_exp)
