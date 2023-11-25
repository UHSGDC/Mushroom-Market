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


var want: Want
var ideal_want: Items.ID
var gives: Array[Give]
var species: Species
var type: Type

