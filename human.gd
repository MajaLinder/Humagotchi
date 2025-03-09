extends Area2D

var current_animation = "" # Tracks the currently playing animation.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_animation("idle")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if Global.human.happiness <= 0:
		#die()
	
func eat() -> void: 
	play_animation("eat")

	
func mousedance() -> void:
	play_animation("mousedance")

	
func shower() -> void:
	play_animation("shower")

	
func show_mood(mood) -> void:
	if mood == "happy":
		play_animation("happy")
	elif mood == "sad":
		play_animation("sad")
	elif mood == "stinky":
		play_animation("stinky")
	else:
		play_animation("idle")

func die() -> void:
	play_animation("death")
	
func play_animation(animation_name):
	current_animation = animation_name
	$AnimatedSprite2D.play(animation_name)
	await get_tree().create_timer(5).timeout  # Wait for 5 seconds
	$AnimatedSprite2D.play("idle")
