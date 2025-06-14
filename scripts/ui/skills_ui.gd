extends Control

@onready var skill_panel: Panel = $Panel/SkillTree/SkillPanel

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('skill_ui'):
		visible = !visible

func _on_visibility_changed() -> void:
	if skill_panel:
		if visible:
			get_tree().call_group("skill_group","startAnim")
			await get_tree().create_timer(0.3).timeout
			skill_panel.drawLines()
		else:
			skill_panel.clearLines()

func _on_back_pressed() -> void:
	visible = false
