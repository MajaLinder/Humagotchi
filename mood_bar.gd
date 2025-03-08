extends AnimatedSprite2D

# TraitFactory class for creating traits
class TraitFactory:
	static func make(type: String) -> Object:
		if type == "gluttony":
			return Gluttony.new(2)
		elif type == "irritability":
			return Irritability.new(1)
		elif type == "cleanliness":
			return Cleanliness.new(1)
		return null

# Gluttony class
class Gluttony:
	var value: int

	func _init(value: int):
		self.value = value

# Irritability class
class Irritability:
	var value: int

	func _init(value: int):
		self.value = value

# Cleanliness class
class Cleanliness:
	var value: int

	func _init(value: int):
		self.value = value

# Human class
class Human:
	var traits: Array
	var gluttony: Gluttony
	var irritability: Irritability
	var cleanliness: Cleanliness
	var state: Dictionary
	var happiness: int = 100
	var alive: bool = true

	func _init(traits: Array):
		self.traits = traits
		self.gluttony = traits[0]
		self.irritability = traits[1]
		self.cleanliness = traits[2]
		self.state = {
			"hungry": 0,
			"stinky": 0,
			"annoyed": 0
		}

	func update_over_time() -> void:
		state["hungry"] += gluttony.value
		state["stinky"] += cleanliness.value
		if happiness < 65:
			state["annoyed"] += irritability.value
		if state["hungry"] > 50:
			state["annoyed"] += irritability.value
		if state["stinky"] > 50:
			state["annoyed"] += irritability.value

		update_happiness()
		alive = happiness > 0

	func update_happiness() -> void:
		var hunger_penalty = state["hungry"] / 7
		var stinky_penalty = state["stinky"] / 7
		print("Stinky penalty: %d" % stinky_penalty)
		print("Hunger penalty: %d" % hunger_penalty)
		happiness -= (hunger_penalty + stinky_penalty + state["annoyed"])

# Action class for performing actions on the human
class Action:
	static func make(type: String, human: Human) -> Object:
		if type == "feed":
			return Feed.new(human)
		elif type == "dance":
			return Dance.new(human)
		elif type == "unhappy":
			return Unhappy.new(human)   
		elif type == "die":
			return Die.new(human)
		else:
			return Exist.new(human)

# Feed class to modify the human's state
class Feed:
	var human: Human

	func _init(human: Human):
		self.human = human
		if human.state["hungry"] < 25:
			human.state["annoyed"] += 1
			human.state["stinky"] += 5
			print("Human not hungry! Human annoyed and stinky!")
			Action.make("unhappy", human)
		else:
			human.happiness += 20
			human.state["hungry"] -= 20
			human.state["stinky"] += 5
			Action.make("dance", human)

class Exist:
	var human: Human

	func _init(human: Human):
		self.human = human

#class triggered when the correct action is performed
class Dance:
	var human: Human

	func _init(human: Human):
		self.human = human

#class triggered when the wrong action is performed
class Unhappy:
	var human: Human

	func _init(human: Human):
		self.human = human


# Die class for making the human dead
class Die:
	var human: Human

	func _init(human: Human):
		human.alive = false

# Main logic to simulate the human's life
func _ready():
	var human = Human.new([
		TraitFactory.make("gluttony"),
		TraitFactory.make("irritability"),
		TraitFactory.make("cleanliness")
	])

	while human.alive:
		human.update_over_time()
		print(human.state)
		print("Happiness: %d" % human.happiness)

		if randf_range(0, 1) > 0.5:
			var action = Action.make("feed", human)
			print("Feeding human")
			print(human.state)

		print("------")
		await get_tree().create_timer(5).timeout

	Action.make("die", human)
