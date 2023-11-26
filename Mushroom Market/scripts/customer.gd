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

enum Type {
	SELLING,
	TRADING,
	BUYING
}

const WANT_WEIGHTS: Dictionary = {
	Species.AXOLOTL : [1, 4, 3, 1, 2],
	Species.TOAD : [2, 2, 2, 3, 2],
	Species.CAECILIAN : [4, 1, 2, 1, 1],
}

const NAMES: Array[String] = ["Nick", "McGuffrey", "Boat", "John", "Jack", "Jake"]
var available_names: Array[String]

var want: Want
var ideal_want: Items.ID
var gives: Array[Give]
var species: Species
var type: Type


func _ready() -> void:
	call_deferred("initialize")

func initialize() -> void:
	species = Species.values().pick_random()
	want = _pick_random_want([1, 1, 1, 1, 1])
	name = _get_random_name()
	texture = load("res://art/market/FancyToad.png")


func _get_random_name() -> String:
	if available_names.is_empty():
		available_names = NAMES.duplicate()
	available_names.shuffle()
	return available_names.pop_back()


func _pick_random_want(weights: Array[int]) -> Want:
	var sum := 0
	for value in weights:
		sum += value
	
	var rnd := randf() * sum
	var summer := 0
	for value in Want.values():
		summer += weights[value]
		if summer > rnd:
			return value
	return -1
