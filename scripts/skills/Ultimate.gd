extends Skill
class_name Ultimate

func _init(target):
	cooldown = 1.0
	animation_name = "Ultimate"
	texture = preload("res://assets/skills/icons_skill/48x48/skill_icons53.png")
	
	super._init(target)
	
func cast_spell(target):
	super.cast_spell(target)
	target.radial(18)
