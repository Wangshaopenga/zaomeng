extends Control

@onready var pet: TextureButton = $Button/Pet
@onready var magic_weapon: TextureButton = $Button/MagicWeapon
@onready var skill: TextureButton = $Button/Skill
@onready var bag: TextureButton = $Button/Bag
@onready var settings: TextureButton = $Button/settings
@onready var skills_ui: Control = $"../SkillsUI"


func _on_skill_pressed() -> void:
	skills_ui.visible = true
