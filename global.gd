extends Node


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
		self.state["hungry"] += self.gluttony.value
		self.state["stinky"] += self.cleanliness.value
		if self.happiness < 65:
			self.state["annoyed"] += self.irritability.value
		if self.state["hungry"] > 50:
			self.state["annoyed"] += self.irritability.value
		if self.state["stinky"] > 50:
			self.state["annoyed"] += self.irritability.value

		update_happiness()
		alive = self.happiness > 0

	func update_happiness() -> void:
		var hunger_penalty = self.state["hungry"] / 7
		var stinky_penalty = self.state["stinky"] / 7
		print("Stinky penalty: %d" % stinky_penalty)
		print("Hunger penalty: %d" % hunger_penalty)
		self.happiness -= (hunger_penalty + stinky_penalty + self.state["annoyed"])

		
		

var human = Human.new([
		TraitFactory.make("gluttony"),
		TraitFactory.make("irritability"),
		TraitFactory.make("cleanliness")
		])
		
		
#Action class for performing actions on the human
class Action:
	static func make(type: String) -> Object:
		if type == "feed":
			return Feed.new(Global.human)
		elif type == "shower":
			return Shower.new(Global.human)
		elif type == "play":
			return Play.new(Global.human)
		elif type == "die":
			return Die.new(Global.human)
		else:
			return Exist.new(Global.human)


#Feed class to modify the human's state
class Feed:
	var human: Human

	func _init(human: Human):
		human = Global.human
		if human.state["hungry"] < 25:
			human.state["annoyed"] += 1
			human.state["stinky"] += 5
			print("Human not hungry! Human annoyed and stinky!")
			Action.make("unhappy")
		else:
			human.happiness += 20
			human.state["hungry"] -= 20
			human.state["stinky"] += 5
			Action.make("dance")
			
class Shower:
	var human: Human

	func _init(human: Human):
		human = Global.human
		if human.state["stinky"] < 25:
			human.state["annoyed"] += 1
			print("Human not stinky! Human annoyed!")

		else:
			human.happiness += 20
			human.state["stinky"] -= 20
			
class Play:
	var human: Human

	func _init(human: Human):
		human = Global.human
		if human.state["hungry"] < 50:
			human.state["annoyed"] += 1
			print("Human not playfull! Human hungry!")

		else:
			human.happiness += 20
			human.state["hungry"] += 10


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

#Die class for making the human dead
class Die:
	var human: Human

	func _init(human: Human):
		human.alive = false
