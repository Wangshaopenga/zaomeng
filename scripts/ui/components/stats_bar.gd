extends Control


@onready var hp_bar: TextureProgressBar = $Bar/HPBar
@onready var hp_label: Label = $Bar/HPBar/Hp
@onready var hp_regen: Label = $Bar/HPBar/HpRegen
@onready var mp_bar: TextureProgressBar = $Bar/MPBar
@onready var mp_label: Label = $Bar/MPBar/Mp
@onready var mp_regen: Label = $Bar/MPBar/MpRegen
@onready var exp_bar: TextureProgressBar = $Bar/EXPBar
@onready var exp_label: Label = $Bar/EXPBar/Exp
@onready var grade_label: Label = $Grade


func _ready() -> void:
	PlayerData.on_hp_changed.connect(self.on_hp_changed)
	PlayerData.on_mp_changed.connect(self.on_mp_changed)
	PlayerData.on_exp_changed.connect(self.on_exp_changed)
	
	PlayerData.useHp(0)
	PlayerData.useMp(0)
	PlayerData.useExp(0)

func on_hp_changed(curr_hp, max_hp):
	hp_label.text = str(curr_hp) + "/" + str(max_hp)
	var percentage = curr_hp / float(max_hp)
	hp_bar.value = percentage

func on_mp_changed(curr_mp, max_mp):
	mp_label.text = str(curr_mp) + "/" + str(max_mp)
	var percentage = curr_mp / float(max_mp)
	mp_bar.value = percentage

func on_exp_changed(curr_exp, max_exp):
	exp_label.text = str(curr_exp) + "/" + str(max_exp)
	var percentage = curr_exp / float(max_exp)
	exp_bar.value = percentage
