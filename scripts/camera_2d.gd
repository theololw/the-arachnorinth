extends Camera2D

var speed = 30

func _process(delta: float) -> void:
	if Input.is_action_pressed("down"):
		position.y += speed
	if Input.is_action_pressed("up"):
		position.y -= speed
	if Input.is_action_pressed("left"):
		position.x -= speed
	if Input.is_action_pressed("right"):
		position.x += speed
	
	if Input.is_action_pressed("zoom in"):
		zoom += Vector2(0.1 * delta,0.1 * delta)
	if Input.is_action_pressed("zoom out"):
		if zoom.x > 0:
			zoom -= Vector2(0.1 * delta,0.1 * delta)
