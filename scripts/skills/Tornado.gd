extends Skill
class_name Tornado

func _init(target):
	cooldown = 1.0
	animation_name = "WaterTornado"
	texture = preload("res://assets/skills/icons_skill/48x48/skill_icons24.png")
	
	super._init(target)
	
func cast_spell(target):
	super.cast_spell(target)
	target.single_shot(animation_name)
