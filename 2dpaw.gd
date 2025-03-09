extends Area2D

var pressed = false

@onready var Tamagotchi = $Tamagotchi

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  # Hide the system cursor
	$AnimatedSprite2D.play("pawidle")  # Play the default animation (idle state)

func _process(delta):
	global_position = get_global_mouse_position()  # Follow the mouse position

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$AnimatedSprite2D.play("pawclick")  # Play the click animation
			check_collision(get_global_mouse_position())  # Check if clicking on any object
		else:
			$AnimatedSprite2D.play("pawidle")  # Return to idle animation

# Function to check collisions with the Area2D node
func check_collision(mouse_pos):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true  # Make sure it collides with areas (like CollisionShape2D)
	query.collide_with_bodies = true  # Make sure it collides with bodies if needed

	var result = space_state.intersect_point(query)

	for i in range(result.size()):  # Loop through the results
		var collider = result[i].collider
		if collider:
			# Trigger on_click function in the collider if it exists
			if collider.has_method("on_click"):
				collider.on_click()  # Call the collider's on_click() function
