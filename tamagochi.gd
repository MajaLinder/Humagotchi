extends Area2D

@onready var human = $Human


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		match shape_idx:
			0:
				human.shower()
				Global.Action.make("shower")
			1:
				human.eat()
				Global.Action.make("feed")
			2:
				human.mousedance()
				Global.Action.make("play")
