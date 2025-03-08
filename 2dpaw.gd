extends AnimatedSprite2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  # Hide system cursor
	play("idle")  # Default animation

func _process(delta):
	global_position = get_global_mouse_position()  # Follow the mouse position

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			play("click")  # Play click animation
			check_collision(get_global_mouse_position())  # Check if clicking an object
		else:
			play("idle")  # Return to idle animation

func check_collision(mouse_pos):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var result = space_state.intersect_point(query)

	for i in range(result.size()):  # Loop through results
		var collider = result[i].collider
		if collider and collider.has_method("on_click"):
			collider.on_click()  # Call object's click function
