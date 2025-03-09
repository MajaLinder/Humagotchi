extends Node2D

# Array of Sprite2D nodes representing happiness levels
@export var happiness_sprites: Array[Sprite2D]

# Happiness level (default: 100)
var happiness = Global.human.happiness

var human = Global.human

# Timer to decrease happiness every second
var happiness_timer: Timer

# Label to display happiness value
@export var happiness_label: Label  # Export the label for linking it in the editor

func _ready():
	# Set up the happiness timer
	happiness_timer = Timer.new()
	happiness_timer.wait_time = 3.0  # 1 second
	happiness_timer.autostart = true
	happiness_timer.one_shot = false
	add_child(happiness_timer)
	
	
	# Correctly connect the signal to the method
	happiness_timer.connect("timeout", Callable(self, "_on_HappinessTimer_timeout"))
	
	# Initial update of the happiness bar and text
	update_happiness_bar()
	update_happiness_text()  # <-- THIS IS WHERE THE TEXT IS UPDATED AT THE START


func update_happiness_bar():
	# Show/hide sprites based on happiness level
	for i in range(happiness_sprites.size()):
		# Each sprite disappears at different happiness thresholds, but we reverse the order
		if happiness > (i * 25):  # Lower happiness thresholds will hide the last sprites first
			happiness_sprites[i].visible = true
		else:
			happiness_sprites[i].visible = false

# Function to update the label text
func update_happiness_text():
	if happiness_label:
		happiness_label.text = "Happiness: " + str(happiness)  # <-- THIS UPDATES THE TEXT OF THE LABEL

func _on_HappinessTimer_timeout():
	if happiness > 0:
		happiness = Global.human.happiness
		human.update_over_time()
		human.update_happiness()
		update_happiness_bar()  # Update the visible happiness bar
		update_happiness_text()  # <-- THIS WILL UPDATE THE LABEL TEXT EVERY SECOND
		print("Happiness: %d" % happiness)
	else:
		print("Happiness is gone!")
		happiness = Global.human.happiness
		happiness_timer.stop()  # Stop the timer when happiness reaches 0
