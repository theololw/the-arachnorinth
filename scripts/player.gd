extends CharacterBody2D

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)

var sight_range = 400
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
var has_walked = false
var local_is_hidden
var has_checked_player = false
var walk_playing = false

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	get_parent().get_node("spider").scale = Vector2(randf_range(0.5,1),randf_range(0.5,1))

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	var last_position = position
	
	if player_in_sight() and (not local_is_hidden or not Global.is_hidden):
		movement_speed = 450
		follow_character()
	
	#elif in_fire_range == true and Global.has_fire == true:
	#	movement_speed = 1000
	#	var relative_position
	#	relative_position = Global.player_position - global_position
	#	set_movement_target((global_position - relative_position))
	#	movement()
	
	elif Global.has_flamethrower:
		movement_speed = 1000
		follow_character()
	else:
		movement_speed = 200
		idle_walk()
	
	
	if player_in_sight():
		if has_checked_player == false:
			has_checked_player = true
			if Global.is_hidden == true:
				local_is_hidden = true
			else:
				local_is_hidden = false
	else:
		has_checked_player = false
	
	# explosion
	if $fire_collider.get_overlapping_areas():
		Global.shake_camera = true
		$explosion.play("explosion")
	
	if position != last_position:
		if $walking_noise.stream_paused != false:
			$walking_noise.stream_paused = false
	else:
		$walking_noise.stream_paused = true
	

func player_in_sight():
	$raycasts.look_at(Global.player_position)
	
	if $raycasts.global_position.distance_to(Global.player_position) < sight_range:
		$raycasts/playerCast.target_position.x = $raycasts.global_position.distance_to(Global.player_position)
		$raycasts/wallCast.target_position.x =  $raycasts.global_position.distance_to(Global.player_position)
	else:
		$raycasts/playerCast.target_position.x = sight_range
		$raycasts/wallCast.target_position.x = sight_range
	
	if $raycasts/playerCast.is_colliding():
		if $raycasts/wallCast.is_colliding():
			return(false)
		else:
			return(true)

func follow_character():
	set_movement_target(Global.player_position)
	
	movement()

func idle_walk():
	if has_walked == false:
		var random_x = randi_range(-50,50)
		var random_y = randi_range(-50,50)
		set_movement_target(global_position + Vector2(random_x, random_y))
		
		has_walked = true
		await get_tree().create_timer(randf_range(0.1,2.0)).timeout
		has_walked = false
	
	movement()
	
func movement():
	if navigation_agent.is_navigation_finished():
		return
	

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	get_parent().get_node("spider/node1").look_at(next_path_position)
	rotation = get_parent().get_node("spider/node1").rotation

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()

func _on_explosion_animation_finished(anim_name: StringName) -> void:
	Global.shake_camera = false
	get_parent().queue_free()
