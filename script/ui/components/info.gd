extends Control

var stats := PlayerData

@onready var hp_bar: TextureProgressBar = $Panel/Bar/HPBar
@onready var hp_label: Label = $Panel/Bar/HPBar/Hp
@onready var hp_regen_label: Label = $Panel/Bar/HPBar/HpRegen
@onready var mp_bar: TextureProgressBar = $Panel/Bar/MPBar
@onready var mp_label: Label = $Panel/Bar/MPBar/Mp
@onready var mp_regen_label: Label = $Panel/Bar/MPBar/MpRegen
@onready var exp_bar: TextureProgressBar = $Panel/Bar/EXPBar
@onready var exp_label: Label = $Panel/Bar/EXPBar/Exp
@onready var grade_label: Label = $Panel/Grade


func _ready() -> void:
	hp_regen_label.visible = stats.hp_regen > 0
	mp_regen_label.visible = stats.mp_regen > 0
	stats.hp_changed.connect(update_hp)
	update_hp()

	stats.mp_changed.connect(update_mp)
	update_mp()

	stats.exp_changed.connect(update_exp)
	update_exp()

	stats.player_death.connect(death)
	stats.upgrade.connect(upgrade)
	tree_exited.connect(func():
			stats.hp_changed.disconnect(update_hp)
			stats.mp_changed.disconnect(update_mp)
			stats.exp_changed.disconnect(update_exp)
			stats.player_death.disconnect(death)
			stats.upgrade.disconnect(upgrade)
	)


func update_hp() -> void:
	print("update hp")
	hp_label.text = str(stats.hp) + "/" + str(stats.max_hp)
	var percentage := stats.hp / float(stats.max_hp)
	hp_bar.value = percentage


func update_mp() -> void:
	print("update mp")
	mp_label.text = str(stats.mp) + "/" + str(stats.max_mp)
	var percentage := stats.mp / float(stats.max_mp)
	print(stats.mp, " ", stats.max_mp)
	mp_bar.value = percentage


func update_exp() -> void:
	print("update exp")
	exp_label.text = str(stats.exp) + "/" + str(stats.max_exp)
	var percentage := stats.exp / stats.max_exp
	exp_bar.value = percentage


func death() -> void:
	print_debug("player death")


func upgrade() -> void:
	grade_label.text = str(stats.grade)
	print_debug("player upgrade")
