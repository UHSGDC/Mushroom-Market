class_name Customer extends Sprite2D

enum Want {
	MONEY,
	MUSHROOM,
	DRINK,
	CURE,
	OTHER_POTION
}

enum Give {
	MONEY,
	MUSHROOM_SEED,
	CRAFTER,
	NATURAL,
	LIGHT,
	MUSHROOM_FOOD,
	KEY
}

enum Species {
	AXOLOTL,
	TOAD,
	CAECILIAN,
}

const WANT_WEIGHTS: Dictionary = {
	Species.AXOLOTL : [1, 4, 3, 1, 2],
	Species.TOAD : [2, 2, 2, 3, 2],
	Species.CAECILIAN : [4, 1, 2, 1, 1],
}

var want: Want
var ideal_want: Items.ID
var gives: Array[Give]
var species: Species


func initialize(_name: String) -> void:
	species = Species.values().pick_random()
	
	name = _name
	texture = load("res://art/market/FancyToad.png") # TEMPORARY, This needs to be a random texture based on species
	
	want = _pick_random_want(WANT_WEIGHTS[species])
	ideal_want = _get_ideal_want(want)
	gives = _get_random_gives(want)


# TEMPORARY
func _get_ideal_want(want: Want) -> Items.ID:
	match want:
		Want.MONEY:
			return Items.ID.NO_ITEM
		Want.MUSHROOM:
			return Items.ID.PURPLE_MUSHROOM
		_:
			return Items.ID.STONE_PATH # Placeholder, because I do not have the potions/drinks/cures implemented


func _get_random_gives(want: Want) -> Array[Give]:
	var randomized_gives: Array[Give]
	for value in Give.values(): randomized_gives.append(value)
	
	randomized_gives.shuffle()
	# Remove money as a give option if the customer wants money
	if want == Want.MONEY:
		randomized_gives.remove_at(randomized_gives.find(Give.MONEY))
	
	var random_number := randf()
	if random_number > 0.8:
		randomized_gives.resize(3)
	elif random_number > 0.4:
		randomized_gives.resize(2)
	else:
		randomized_gives.resize(1)
	
	return randomized_gives


func _pick_random_want(weights: Array) -> Want:
	# temp code
	var _weights = weights.duplicate()
	_weights.resize(2)
	var wants = Want.values()
	wants.resize(2)
	# end of temp code
	var sum := 0
	for value in _weights:
		sum += value
	
	var rnd := randf() * sum
	var summer := 0
	for value in wants:
		summer += weights[value]
		if summer > rnd:
			return value
	return -1
