extends CharacterBody2D
class_name player

var speed = 500  # speed in pixels/sec
const default_speed = 600
var spider_in_area = false
var spider_in_area_amount = 0
var heelcklacking
var caught = false
var playing_insane_music = false
var is_walking = false

var has_shot = false

@onready var anim_player = $AnimationPlayer
@onready var fire = preload("res://scenes/fire.tscn")


func _physics_process(delta):
	# novement and ui
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	
	Global.player_position = global_position
	$ui/run_bar.value = speed
	$"ui/electricity bar".value = Global.electricity
	
	
	# compass
	if not Global.has_flamethrower:
		var direction_to_flamethrower = global_position.direction_to(Global.flamethrower_position)
		$Node2D/compass.global_position = global_position + (direction_to_flamethrower * 150)
		$Node2D/compass.look_at(position)
		$Node2D/direction_to_the_goal.position = $Node2D/compass.position
	else:
		$Node2D/compass.hide()
	
	# camera controls
	if Input.is_action_pressed("look") or Global.has_flamethrower:
		$Camera2D.offset = get_local_mouse_position()/4
	else:
		$Camera2D.offset = Vector2.ZERO
	
	# hiding
	if Input.is_action_pressed("hide") and Global.electricity > 0:
		Global.is_hidden = true
		Global.electricity -= 10 * delta
		$Node2D/Polygon2D.show()
	
	# escaping
	elif not heelcklacking:
		Global.is_hidden = false
		$Node2D/Polygon2D.hide()
		if spider_in_area and speed > 0:
			speed -= (40 * spider_in_area_amount) * delta
		elif not spider_in_area and speed < default_speed:
			speed += 90 * delta
	elif heelcklacking:
		speed = default_speed + 300
	
	if $spider_in_area.get_overlapping_areas():
		$Node2D/GPUParticles2D.emitting = true
		spider_in_area = true
		spider_in_area_amount = $spider_in_area.get_overlapping_areas().size()
	else:
		spider_in_area = false
		$Node2D/GPUParticles2D.emitting = false
	
	# dying
	if speed < 20:
		if Global.lifes_left == 0:
			get_tree().change_scene_to_file("res://scenes/lose_scene.tscn")
		else:
			caught = true
			$caught.show()
			if Input.is_action_just_pressed("emote"):
				Global.lifes_left -= 1
				heelcklacking = true
				anim_player.play("heelclack")
	else:
		$caught.hide()
		
	
	# animations
	if Input.is_action_pressed("left") and not heelcklacking:
		anim_player.play("walk_left")
		is_walking = true
	elif Input.is_action_pressed("right") and not heelcklacking:
		anim_player.play("walk_right")
		is_walking = true
	elif (Input.is_action_pressed("up") or Input.is_action_pressed("down")) and not heelcklacking:
		anim_player.play("walk_forward")
		is_walking = true
	elif not heelcklacking:
		anim_player.play("idle")
		is_walking = false
		
	if is_walking == true:
		if $AudioListener2D/walking.stream_paused != false:
			$AudioListener2D/walking.stream_paused = false
	else:
		$AudioListener2D/walking.stream_paused = true
	
	
	
	# exterminating
	if Global.has_flamethrower:
		$"ui/SPIDERS LEFT/SPIDERS LEFT2".text = str(get_tree().get_nodes_in_group("spider").size())
		$"ui/SPIDERS LEFT".show()
		speed = default_speed
		$"flamethrower".show()
		$flamethrower.look_at(get_global_mouse_position())
		if get_local_mouse_position().x < 0:
			$"flamethrower".scale.y = -1
		else:
			$"flamethrower".scale.y = 1
		
		# shooting
		if Input.is_action_pressed("shoot") and not has_shot:
			has_shot = true
			var fire_instance = fire.instantiate()
			fire_instance.global_position = $"flamethrower/ft-png/nozzle".global_position
			fire_instance.fire_velocity = global_position.direction_to(get_global_mouse_position()) * 14
			get_parent().add_child(fire_instance)
			await get_tree().create_timer(0.1).timeout
			has_shot = false
		if get_tree().get_nodes_in_group("spider").size() < 1:
			get_tree().change_scene_to_file("res://scenes/win_scene.tscn")
		
		

			
	else:
		$flamethrower.hide()
	
	if Global.shake_camera == true:
		shake()
		Global.shake_camera = false


func shake():
	var amount = 0.2
	$Camera2D.rotation = 1 * amount * randf_range(-1, 1)
	$Camera2D.position.x = Vector2(100, 75).x * amount * randf_range(-1, 1)
	$Camera2D.position.y = Vector2(100, 75).y * amount * randf_range(-1, 1)

	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "heelclack":
		heelcklacking = false
		speed = default_speed
