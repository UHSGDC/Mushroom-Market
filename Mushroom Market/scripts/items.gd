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
	POT,
	BLUE_LAMP = 20, # 20 - 29 is reserved for lights and lamps
	MAGIC_LAMP,
	OIL_LANTERN,
	CRATE = 40, # 40 - 49 is for all misc. whole tiles
	COBBLESTONE_PATH = 50, # 50 - 59 is reserved for path tiles
	STONE_PATH,
	DIRT = 60, # 60 - 69 is reserved for dirt and soil tiles
	RED_SOIL,
	PURPLE_SOIL,
	GREEN_SOIL,
	PURPLE_SHROOM_SEED = 70, # 70-89 is reserved for mushroom seeds
	CHECKERS_SHROOM_SEED,
	BRY_SHROOM_SEED,
	CROW_SHROOM_SEED,
	DERP_SHROOM_SEED,
	DESERT_SHROOM_SEED,
	EGGPLANT_SHROOM_SEED,
	EGG_SHROOM_SEED,
	MOSSY_SHROOM_SEED,
	BUSH_SHROOM_SEED,
	SCARLET_SHROOM_SEED,
	SKULL_SHROOM_SEED,
	TOAD_SHROOM_SEED,
	LONG_STALK_SHROOM_SEED,
	UMBRELLA_SHROOM_SEED
}

var item_data: Array[ItemData] = [
	preload("res://items/dirt.tres"),
	preload("res://items/red_soil.tres"),
	preload("res://items/composter.tres"),
	preload("res://items/cauldron.tres"),
	preload("res://items/stone_path.tres"),
	preload("res://items/cobblestone_path.tres"),
	preload("res://items/blue_lamp.tres"),
	preload("res://items/mushrooms/purple_shroom_seed.tres"),
	preload("res://items/crate.tres"),
	preload("res://items/green_soil.tres"),
	preload("res://items/magic_lamp.tres"),
	preload("res://items/oil_lantern.tres"),
	preload("res://items/pot.tres"),
	preload("res://items/purple_soil.tres"),
	preload("res://items/mushrooms/bry_shroom_seed.tres"),
	preload("res://items/mushrooms/bush_shroom_seed.tres"),
	preload("res://items/mushrooms/checkers_shroom_seed.tres"),
	preload("res://items/mushrooms/crow_shroom_seed.tres"),
	preload("res://items/mushrooms/derp_shroom_seed.tres"),
	preload("res://items/mushrooms/desert_shroom_seed.tres"),
	preload("res://items/mushrooms/eggplant_shroom_seed.tres"),
	preload("res://items/mushrooms/egg_shroom_seed.tres"),
	preload("res://items/mushrooms/long_stalk_shroom_seed.tres"),
	preload("res://items/mushrooms/mossy_shroom_seed.tres"),
	preload("res://items/mushrooms/skull_shroom_seed.tres"),
	preload("res://items/mushrooms/scarlet_shroom_seed.tres"),
	preload("res://items/mushrooms/toad_shroom_seed.tres"),
	preload("res://items/mushrooms/umbrella_shroom_seed.tres"),
	
]

var data_from_id: Dictionary
var id_from_tile: Dictionary = { -1 : ID.NO_ITEM }

func _ready() -> void:
	initiliaze_item_dictionaries()


func initiliaze_item_dictionaries() -> void:
	for item in item_data:
		if item.use_tags.has(Use.TILEMAP):
			if id_from_tile.has(item.tile_id):
				print(ID.find_key(id_from_tile[item.tile_id]))
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
	return id >= 40 and id < 50
	
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
