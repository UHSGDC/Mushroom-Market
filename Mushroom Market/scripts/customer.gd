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
	ideal_want = _get_ideal_want()
	gives = _get_random_gives()


# TEMPORARY
func _get_ideal_want() -> Items.ID:
	match want:
		Want.MONEY:
			return Items.ID.NO_ITEM
		Want.MUSHROOM:
			return Items.ID.PURPLE_MUSHROOM
		_:
			return Items.ID.STONE_PATH # Placeholder, because I do not have the potions/drinks/cures implemented


func _get_random_gives() -> Array[Give]:
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


func talk_to_player() -> void:
	Global.play_dialog.call(name, inital_statement(), ["Accept", "Decline"])


func inital_statement() -> String:
#	var give_text: String = ""
#	for give in gives:
#		if give_text != "":
#			give_text += ", "
#			if gives[-1] == give:
#				give_text += "and "	
#		give_text += Give.find_key(give).to_lower().replace("_", " ")
#		if give != Give.MONEY and give != Give.MUSHROOM_FOOD:
#			give_text += "s"
#
#	var want_text = Want.find_key(want).to_lower()
#	if want != Want.MONEY:
#		want_text += "s"
	
	var give_item := Items.get_item_data(get_give_item(gives.pick_random()))
	var want_item := Items.get_item_data(get_want_item(want))
	
	var give_text: String = ""
	var want_text: String = ""
	
	var give_count := 1
	var want_count := 1
	if (!want_item):
		want_count = give_item.price
		want_text = str(want_count) + " Moneys"
		give_text = "1 " + give_item.name
	elif (!give_item):
		give_count = want_item.price
		give_text = str(give_count) + " Moneys"
		want_text = "1 " + want_item.name
	else:
		var price_diff: int = give_item.price - want_item.price
		while(abs(price_diff) > 2):
			if price_diff < 0:
				give_count += 2
			else:
				want_count += 2
			price_diff = give_item.price - want_item.price
		
		give_text = str(give_count) + " " + give_item.name
		want_text = str(want_count) + " " + want_item.name
		
	return "I am looking for %s and I can give you %s. What do you think?" % [want_text, give_text]
	
const MUSHROOMS = [Items.ID.PURPLE_MUSHROOM]
const MUSHROOM_SEEDS = [Items.ID.PURPLE_MUSHROOM_SEED]
const NATURALS = [Items.ID.DIRT, Items.ID.STONE_PATH]
const LIGHTS = [Items.ID.BLUE_LAMP]

func get_give_item(give: Give) -> Items.ID:
	match give:
		Give.MONEY:
			return Items.ID.NO_ITEM
		Give.MUSHROOM_SEED:
			return MUSHROOM_SEEDS.pick_random()
		Give.NATURAL:
			return NATURALS.pick_random()
		Give.MUSHROOM_FOOD:
			return Items.ID.MUSHROOM_FOOD
		Give.LIGHT:
			return LIGHTS.pick_random()
	return Items.ID.NO_ITEM
	

func get_want_item(want: Want) -> Items.ID:
	match want:
		Want.MONEY:
			return Items.ID.NO_ITEM
		Want.MUSHROOM:
			return MUSHROOMS.pick_random()	
		_:
			return Items.ID.NO_ITEM
	
