class_name Player
extends BaseCharacter

## Player character class that handles movement, combat, and state management
@export var invulnerable_duration: float = 2
var is_invulnerable: bool = false
var invulnerable_timer: float = 0
const FLICKER_INTERVAL := 0.1
var flicker_timer := 0.0

@export var has_blade: bool = false
var blade_hit_area: Area2D;
@export var blade_throw_speed: float = 300
@onready var blade_factory: Node2DFactory = $Direction/BladeFactory

@onready var jump_fx_factory: Node2DFactory = $Direction/JumpFXFactory

func _ready() -> void:
	super._ready()
	fsm = FSM.new(self, $States, $States/Idle)
	if has_blade:
		collected_blade()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	invulnerable_timer -= delta
	
	if (invulnerable_timer <= 0):
		is_invulnerable = false
		
	if is_invulnerable:
		invulnerable_flicker(delta)
	else:
		animated_sprite.modulate.a = 1

func invulnerable_flicker(delta) -> void:
	flicker_timer += delta
	if flicker_timer >= FLICKER_INTERVAL:
		flicker_timer = 0.0
		animated_sprite.modulate.a = 1/(animated_sprite.modulate.a/(0.4*0.7))

func can_attack() -> bool:
	return has_blade

func collected_blade() -> void: 
	has_blade = true
	set_animated_sprite($Direction/BladeAnimatedSprite2D)

func throw_blade() -> void:
	var blade = blade_factory.create() as RigidBody2D
	var throw_velocity := Vector2(blade_throw_speed * direction, 0.0)
	blade.direction = direction
	blade.apply_impulse(throw_velocity)
	throwed_blade()

func throwed_blade() -> void:
	has_blade = false
	set_animated_sprite($Direction/AnimatedSprite2D)

func set_invulnerable() -> void:
	is_invulnerable = true
	invulnerable_timer = invulnerable_duration

func is_char_invulnerable() -> bool:
	return is_invulnerable
	
func jump() -> void:
	super.jump()
	var jump_fx = jump_fx_factory.create() as Node2D

func _on_hurt_area_2d_hurt(_direction: Variant, _damage: Variant) -> void:
	fsm.current_state.take_damage(_direction, _damage)
