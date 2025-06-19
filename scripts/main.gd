extends Node2D

@onready var spider = preload("res://scenes/spider_pack.tscn")
@onready var torch_altar = preload("res://scenes/torch_altar.tscn")
@onready var flamethrower = preload("res://scenes/flamethrower.tscn")
func _ready() -> void:
	$%creating_level.show()
	$Camera2D.enabled = true
	get_tree().paused = true
func _on_generator_done() -> void:
	spawn_spiders(50)
	spawn_torch_altars(40)
	spawn_flamethrower()
	$%creating_level.hide()
	$Camera2D.enabled = false
	get_tree().paused = false

func _process(delta: float) -> void:
	pass

func spawn_spiders(amount):
	for i in range(amount):
		var random_x = randi_range(3,31)
		var random_y = randi_range(3,25)
		var scaled_x = random_x * 288
		var scaled_y = random_y * 288
		
		var spider_instance = spider.instantiate()
		spider_instance.hide()
		spider_instance.position = Vector2(scaled_x-144,scaled_y-144)
		$spiders.add_child(spider_instance)
		spider_instance.show()

func spawn_torch_altars(amount):
	for i in range(amount):
		var random_x = randi_range(0,15)
		var random_y = randi_range(0,12)
		var scaled_x = random_x * 576
		var scaled_y = random_y * 576
		
		var torch_altar_instance = torch_altar.instantiate()
		torch_altar_instance.position = Vector2(scaled_x,scaled_y)
		add_child(torch_altar_instance)
func spawn_flamethrower():
	var random_x = randi_range(10,14)
	var random_y = randi_range(8,11)
	var scaled_x = random_x * 576
	var scaled_y = random_y * 576
		
	var flamethrower_instance = flamethrower.instantiate()
	flamethrower_instance.position = Vector2(scaled_x,scaled_y)
	add_child(flamethrower_instance)
	Global.flamethrower_position = Vector2(scaled_x,scaled_y)
	
func _on_spider_cooldown_timeout() -> void:
	spawn_spiders(1)
