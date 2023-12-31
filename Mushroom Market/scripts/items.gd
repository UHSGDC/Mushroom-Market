extends Node

enum Use {
	TILEMAP,
	TRADEABLE,
	OTHER
}


enum ID {
	NO_ITEM = -1,
	CAULDRON = 10, # 10 - 19 is reserved for crafting items
	COMPOSTER,
	FERMENTER,
	BLUE_LAMP = 20, # 20 - 29 is reserved for lights and lamps
	MAGIC_LAMP,
	OIL_LANTERN,
	KEY = 30, # 30 - 39 is reserved for misc. items
	MUSHROOM_FOOD,
	CRATE = 40, # 40 - 49 is for all misc. whole tiles
	GRAVEL_PATH = 50, # 50 - 59 is reserved for path tiles
	STONE_PATH,
	DIRT = 60, # 60 - 69 is reserved for dirt and soil tiles
	RED_SOIL,
	PURPLE_SOIL,
	GREEN_SOIL,
	PURPLE_MUSHROOM_SEED = 70, # 70-89 is reserved for mushroom seeds
	PURPLE_MUSHROOM = 90, # 90 and up is reserved for tradeable, craftable and other items
}

var item_data: Array[ItemData] = [
	preload("res://items/dirt.tres"),
	preload("res://items/red_soil.tres"),
	preload("res://items/purple_mushroom.tres"),
	preload("res://items/purple_mushroom_seed.tres"),
	preload("res://items/composter.tres"),
	preload("res://items/cauldron.tres"),
	preload("res://items/stone_path.tres"),
	preload("res://items/blue_lamp.tres"),
]

var data_from_id: Dictionary
var id_from_tile: Dictionary = { -1 : ID.NO_ITEM }

func _ready() -> void:
	initiliaze_item_dictionaries()


func initiliaze_item_dictionaries() -> void:
	for item in item_data:
		if item.use_tags.has(Use.TILEMAP):
			if id_from_tile.has(item.tile_id):
				assert(false, "two tilemap items with same tile id")
			id_from_tile[item.tile_id] = item.id
		if data_from_id.has(item.id):
			assert(false, "two items with same id")
		data_from_id[item.id] = item


func get_item_data(id: ID) -> ItemData:
	if id < 0:
		return null
	
	var data: ItemData = data_from_id.get(id)
	
	if !data:
		push_warning("ItemData for id: " + str(id) + " not found")

	return data


func get_id_from_tile(tile_id: int) -> ID:
	var id: ID = id_from_tile.get(tile_id)
	
	if !id:
		push_warning("ID for tile id: " + str(tile_id) + " not found")

	return id


func get_data_from_tile(tile_id: int) -> ItemData:
	return get_item_data(get_id_from_tile(tile_id))

func is_crafter(id: ID) -> bool:
	return id >= 10 and id < 20
	
func is_light(id: ID) -> bool:
	return id >= 20 and id < 30
	
func is_misc(id: ID) -> bool:
	return id >= 30 and id < 40
	
func is_whole(id: ID) -> bool:
	return id >= 40 and id < 70
	
func is_path(id: ID) -> bool:
	return id >= 50 and id < 60
	
func is_soil(id: ID) -> bool:
	return id >= 60 and id < 70
	
func is_dirt(id: ID) -> bool:
	return id == ID.DIRT
	
func is_natural(id: ID) -> bool:
	return is_path(id) or is_soil(id)
	
func is_mushroom(id: ID) -> bool:
	return id >= 70 and id < 90
