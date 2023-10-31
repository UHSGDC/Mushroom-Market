extends Node

enum Use {
	REPLACE_WHOLE,
	PLACE_WHOLE,
	USE,
}


enum ID {
	CAULDRON = 10, # 10 - 19 is reserved for crafting items
	COMPOSTER,
	FERMENTER,
	LIGHT = 20, # 20 - 29 is reserved for lights and lamps
	KEY = 30, # 30 - 39 is reserved for misc. items
	MUSHROOM_FOOD,
	CRATE = 40, # 40 - 49 is for all misc. whole tiles
	GRAVEL_PATH = 50, # 50 - 59 is reserved for path tiles
	STONE_PATH,
	DIRT = 60, # 60 - 69 is reserved for dirt and soil tiles
	NUTRITIOUS_SOIL,
	MUSHROOM = 70, # 70-89 is reserved for mushrooms
}

var item_data: Array[ItemData] = [
	preload("res://items/dirt.tres"),
	preload("res://items/mushroom.tres"),
	preload("res://items/composter.tres"),
]

func get_item_data(id: ID) -> ItemData:
	if id < 0:
		return null
	
	for item in item_data:
		if item.id == id:
			return item
	
	assert(false, "ItemData for id: " + str(id) + " not found")
	return null
