class_name EnemyCharacter
extends BaseCharacter

# Raycast check wall and fall
var front_ray_cast: RayCast2D
var down_ray_cast: RayCast2D

# Raycast detect player (left / right)
var left_detect_ray: RayCast2D
var right_detect_ray: RayCast2D

# Player reference
var found_player: Player = null


func _ready() -> void:
	_init_ray_cast()
	_init_detect_player_raycast()
	_init_hurt_area()
	super._ready()


# --- Initialize raycasts for wall/fall detection
func _init_ray_cast():
	if has_node("Direction/FrontRayCast2D"):
		front_ray_cast = $Direction/FrontRayCast2D
	if has_node("Direction/DownRayCast2D"):
		down_ray_cast = $Direction/DownRayCast2D


# --- Initialize raycasts for detecting player
func _init_detect_player_raycast():
	if has_node("Direction/LeftDetectRayCast2D"):
		left_detect_ray = $Direction/LeftDetectRayCast2D
	if has_node("Direction/RightDetectRayCast2D"):
		right_detect_ray = $Direction/RightDetectRayCast2D


# --- Initialize hurt area
func _init_hurt_area():
	if has_node("Direction/HurtArea2D"):
		var hurt_area = $Direction/HurtArea2D
		hurt_area.hurt.connect(_on_hurt_area_2d_hurt)


# --- Check if touching wall
func is_touch_wall() -> bool:
	return front_ray_cast != null and front_ray_cast.is_colliding()


# --- Check if can fall
func is_can_fall() -> bool:
	return down_ray_cast != null and not down_ray_cast.is_colliding()


# --- Called every frame (or physics frame)
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_check_player_in_sight()


# --- Check player detection via raycast
func _check_player_in_sight():
	var detected_player := _get_player_from_raycasts()
	
	if detected_player != found_player:
		if detected_player:
			found_player = detected_player
			_on_player_in_sight(found_player.global_position)
		else:
			_on_player_not_in_sight()
			found_player = null


# --- Helper: returns player if any raycast hit it
func _get_player_from_raycasts() -> Player:
	if left_detect_ray and left_detect_ray.is_colliding():
		var collider = left_detect_ray.get_collider()
		if collider is Player:
			return collider

	if right_detect_ray and right_detect_ray.is_colliding():
		var collider = right_detect_ray.get_collider()
		if collider is Player:
			return collider

	return null


# --- Called when player is in sight
func _on_player_in_sight(_player_pos: Vector2) -> void:
	print("Player detected at:", _player_pos)


# --- Called when player is not in sight
func _on_player_not_in_sight() -> void:
	print("Player lost from sight")


# --- When enemy takes damage
func _on_hurt_area_2d_hurt(_direction: Vector2, _damage: float) -> void:
	_take_damage_from_dir(_direction, _damage)


# --- Apply damage through FSM
func _take_damage_from_dir(_damage_dir: Vector2, _damage: float):
	fsm.current_state.take_damage(_damage_dir, _damage)
