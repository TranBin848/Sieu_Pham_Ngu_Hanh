extends Area2D

var speed: float = 250
var direction: Vector2 = Vector2.RIGHT:
	set(value):
		direction = value
		if $AnimatedSprite2D.animation != "WaterTornado":
			rotation = direction.angle() 
			
func _physics_process(delta: float) -> void:
	position += speed * direction * delta
			
func play(animation_name = "Fire"):
	$AnimatedSprite2D.play(animation_name)
			
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
