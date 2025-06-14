extends Control


@onready var _level = $VBoxContainer/Level
@onready var image = $VBoxContainer/TextureRect
@onready var _name = $VBoxContainer/Name
@onready var _info = $VBoxContainer/Info
@onready var _pre = $VBoxContainer/Pre
@onready var _str = $VBoxContainer/Str
@onready var upgrade = $VBoxContainer/HBoxContainer/Upgrade
@onready var _key = $VBoxContainer/HBoxContainer/key
var current_skill

func _ready() -> void:
	SkillUtils.on_skill_click.connect(self.on_skill_click)
	SkillUtils.on_skill_upgrade.connect(self.on_skill_click)

func on_skill_click(skill:Skill):
	current_skill = skill
	_name.text = current_skill.name
	if current_skill.current_level == 0:
		_level.text =  '尚未学习'
		image.modulate = Color('#2e2e2e')
	else:
		_level.text = "Lv.%s" %current_skill.current_level
		image.modulate = Color.WHITE
	image.texture = current_skill.icon
	_str.set("theme_override_colors/font_color","#d682eb")
	_str.text = "消耗体力：%s" %current_skill.mp
	_info.text = "天赋介绍:\n"+current_skill.get_dynamic_description()
	
	_key.visible = current_skill.type == Consts.Type.Active
	
	if Game.key_map.has(current_skill.bindKye):
		_key.text = "已设置"
	else:
		_key.text = "未设置按键"
	
	if current_skill.prerequisites:
		_pre.text = '需要天赋：'
		var index = 0 
		for t in current_skill.prerequisites:
			if index > 0:
				_pre.text += " | "
			_pre.text += t.name
			index += 1
	else:
		_pre.text = '需要天赋：无'

# 升级天赋
func _on_upgrade_pressed() -> void:
	if current_skill:
		var code = SkillUtils.upgradeSkill(current_skill)

func _on_key_pressed() -> void:
	if SkillUtils.getSkill(current_skill.id):
		Game.addSkillButton(current_skill)
	else:
		MessageBox.alert("请先学习天赋后再配置按键！")
