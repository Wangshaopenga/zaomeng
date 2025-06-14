extends Panel

var skill_node_dict = {}
var draw_lines = []
var line_color = Color.WHITE

func _ready() -> void:
	for skill_node in get_children():
		skill_node_dict[skill_node.skill.id] = skill_node
		skill_node.skill.position = skill_node.position

func drawLines():
	draw_lines.clear()
	for skill_node in get_children():
		var target_skill = skill_node.skill as Skill
		for skill in target_skill.prerequisites:
			draw_lines.append([target_skill.position,skill_node_dict[skill.id].position])
	queue_redraw()
	
func clearLines():
	draw_lines.clear()
	queue_redraw()

func _draw() -> void:
	for lines in draw_lines:
		var start = lines[0] + Vector2(20,20)
		var end = lines[1] + Vector2(20,20)
		draw_dashed_line(start,end,line_color,1,4,true,false)
