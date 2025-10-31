extends Skill
class_name WaterBall

func _init(target):
	cooldown = 1.0
	animation_name = "WaterBlast"
	texture = preload("res://assets/skills/icons_skill/48x48/skill_icons23.png")
	
	super._init(target)
	
func cast_spell(target):
	super.cast_spell(target)
	target.multi_shot(2, 0.4, animation_name)
