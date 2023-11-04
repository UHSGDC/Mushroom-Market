class_name TileManager extends Node2D

enum Mode {
	MUSHROOM,
	DIRT,
	SOIL,
	PATH,
	MUSHROOM_MODIFIER,
	OTHER_TILE,
	REMOVE,
	SELECT,
	NONE
}

@export var layers: Array[TileMap]

var tile: ItemData = null
var mode: Mode = Mode.SELECT :
	set(value):
		mode = value
		preview.mode = value
		
var _layer_index: int : 
	set(value):
		_layer_index = value
		preview.layer_index = value
		
var _current_tile: Vector2i
var _is_tile_valid: bool = false
var crafters_to_progress: Array[Array]

@onready var _tile_size: int = layers[0].tile_set.tile_size.x
@onready var preview: Sprite2D = $Preview


func _ready() -> void:
	Global.day_cycled.connect(_on_day_cycled)
	Global.item_selected.connect(_on_item_selected)


func _process(delta: float) -> void:
	_layer_index = _check_for_tiles(layers.duplicate(), _tile_size)
		
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("change_tile"):
		_edit_tile_at_mouse(_layer_index, layers.duplicate())


func _on_day_cycled() -> void:
	for layer in layers:
		# TO DO Mushrooms will also check for soil, any modifiers on them, adjacent space, adjacent lamps, adjacent mushrooms, humidity(idk what determines this). Once one of these tiles are ready for harvest/collection there will be some sort of indication to the player. Clicking on the tile while in select mode will harvest the tile.
		for cell in layer.get_used_cells(0):
			var tile_id := layer.get_cell_source_id(0, cell)
			var item_id := Items.get_id_from_tile(tile_id)
			if Items.is_mushroom(item_id):
				var atlas_coords := layer.get_cell_atlas_coords(0, cell)
				if atlas_coords.y < 2:
					layer.set_cell(0, cell, tile_id, atlas_coords + Vector2i.DOWN)
			if Items.is_crafter(item_id):
				var atlas_coords := layer.get_cell_atlas_coords(0, cell)
				if atlas_coords.y < 2 and crafters_to_progress.has([layer, cell]):
					layer.set_cell(0, cell, tile_id, atlas_coords + Vector2i.DOWN)


func _on_item_selected(item: Items.ID) -> void:
	preview.texture = null
	mode = Mode.SELECT
	tile = Items.get_item_data(item)
	if !tile:
		return
		
	if tile.use_tags.has(Items.Use.TILEMAP):
		preview.texture = tile.place_texture
		mode = tile.place_mode


func _edit_tile_at_mouse(layer_index: int, layer_list: Array[TileMap]) -> void:
	var layer = layer_list[layer_index]
	if !_is_tile_valid:
		return
	match mode:
		Mode.REMOVE:
			layer.set_cell(0, _current_tile, -1)
		Mode.SELECT:
			print("selecting tile")
			# show stats or harvest tile
		Mode.NONE:
			print("currently doing nothing")
		Mode.MUSHROOM_MODIFIER:
			print("modify this shroom!!!")
		_:
			layer.set_cell(0, _current_tile, tile.tile_id, Vector2i(0, 0))
			Global.change_inventory_item.call(tile.id, -1)
	
	
func _check_for_tiles(layer_list: Array[TileMap], tile_size: int) -> int:
	for i in range(layer_list.size() - 1, -1, -1):
		var layer: TileMap = layer_list[i]
		var tile_pos := layer.local_to_map(layer.get_local_mouse_position())
		var tile_id := layer.get_cell_source_id(0, tile_pos)
		var tile_item_id: Items.ID = Items.get_id_from_tile(tile_id)
		var tile_above_id := layer_list[i + 1].get_cell_source_id(0, tile_pos) if i < layer_list.size() - 1 else -2
		
		var offset_tile_pos := layer.local_to_map(layer.get_local_mouse_position() + Vector2.UP * tile_size / 2)
		var offset_tile_id :=  layer.get_cell_source_id(0, offset_tile_pos)
		match mode:
			Mode.MUSHROOM:
				if tile_id != -1 and tile_above_id == -1 and Items.is_soil(tile_item_id):
					_current_tile = tile_pos
					i += 1
				else:
					continue
			Mode.OTHER_TILE:
				if tile_id != -1 and tile_above_id == -1 and Items.is_whole(tile_item_id):
					_current_tile = tile_pos
					i += 1
					if Items.is_crafter(tile.id):
						crafters_to_progress.append([layers[i], tile_pos])
				else:
					continue
			Mode.DIRT:
				if Items.is_whole(tile_item_id) and tile_above_id == -1:
					_current_tile = tile_pos
					i += 1
				else:
					continue
			Mode.SOIL:
				if Items.is_dirt(tile_item_id) and (tile_above_id < 0 or Items.is_mushroom(Items.get_id_from_tile(tile_above_id))):
					_current_tile = tile_pos
				else:
					continue
			Mode.PATH:
				if Items.is_dirt(tile_item_id) and tile_above_id < 0:
					_current_tile = tile_pos
				else:
					continue
			Mode.MUSHROOM_MODIFIER:
				if Items.is_mushroom(tile_item_id):
					_current_tile = tile_pos
				elif Items.is_mushroom(Items.get_id_from_tile(offset_tile_id)):
					_current_tile = offset_tile_pos
				else:
					continue
			Mode.SELECT:
				if tile_id != -1:
					_current_tile = tile_pos
				elif layer.get_cell_source_id(0, offset_tile_pos) != -1:
					_current_tile = offset_tile_pos
				else:
					continue
			Mode.REMOVE:
				if tile_id != -1:
					_current_tile = tile_pos
				elif layer.get_cell_source_id(0, offset_tile_pos) != -1:
					_current_tile = offset_tile_pos
				else:
					continue
			Mode.NONE:
				continue
		var offset := Vector2i.UP * (tile_size / 2 * i)
		preview.show()
		_is_tile_valid = true
		preview.global_position = _current_tile * tile_size + offset
		return i
	
	preview.hide()
	_is_tile_valid = false
	return -1
