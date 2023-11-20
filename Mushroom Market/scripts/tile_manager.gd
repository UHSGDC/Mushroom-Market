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
@export var light_scene: PackedScene

var tile: ItemData = null
var mode: Mode = Mode.SELECT :
	set(value):
		mode = value
		preview.mode = value
		
var _layer_index: int
var tile_below_empty: bool = false
var _current_tile: Vector2i
var _is_tile_valid: bool = false
var crafters_to_progress: Array[Array]
var light_tile_to_scene: Dictionary
var path_placement: int = 1
var selecting_side: bool = false

@onready var _tile_size: int = layers[0].tile_set.tile_size.x
@onready var preview: Sprite2D = $Preview


func _ready() -> void:
	Global.day_cycled.connect(_on_day_cycled)
	Global.item_selected.connect(_on_item_selected)
	Global.shovel_selected.connect(_shovel_selected)


func _process(delta: float) -> void:
	var layer_index := _check_for_tiles(layers.duplicate(), _tile_size)
	tile_below_empty = layers[layer_index].get_cell_source_id(0, _current_tile + Vector2i.DOWN) == -1
	_set_layer_index(layer_index, tile_below_empty)
	
		
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("change_tile"):
		_edit_tile_at_mouse(_layer_index, layers.duplicate())


func _set_layer_index(value: int, elevate_side: bool):
	_layer_index = value
	modulate = layers[value].modulate
	preview.set_layer_index(value, elevate_side)
	

func _on_day_cycled() -> void:
	for layer_index in layers.size():
		var layer := layers[layer_index]
		# TO DO Mushrooms will also check for soil, any modifiers on them, adjacent space, adjacent lamps, adjacent mushrooms, humidity(idk what determines this). Once one of these tiles are ready for harvest/collection there will be some sort of indication to the player. Clicking on the tile while in select mode will harvest the tile.
		for cell in layer.get_used_cells(0):
			var tile_id := layer.get_cell_source_id(0, cell)
			var item_id := Items.get_id_from_tile(tile_id)
			if Items.is_mushroom(item_id):
				var atlas_coords := layer.get_cell_atlas_coords(0, cell)
				if atlas_coords.y < 2:
					atlas_coords.y += 1
					# This will double the speed of growth for red soil
					if Items.get_id_from_tile(layers[layer_index - 1].get_cell_source_id(0, cell)) == Items.ID.RED_SOIL:
						atlas_coords.y = 2
					layer.set_cell(0, cell, tile_id, atlas_coords)
			if Items.is_crafter(item_id):
				var atlas_coords := layer.get_cell_atlas_coords(0, cell)
				if atlas_coords.y < 2 and crafters_to_progress.has([layer, cell]):
					layer.set_cell(0, cell, tile_id, atlas_coords + Vector2i.DOWN)


func _shovel_selected() -> void:
	_on_item_selected(Items.ID.NO_ITEM)
	mode = Mode.REMOVE


func _on_item_selected(item: Items.ID) -> void:
	preview.texture = null
	mode = Mode.SELECT
	tile = Items.get_item_data(item)
	if !tile:
		return
		
	if tile.use_tags.has(Items.Use.TILEMAP):
		preview.texture = tile.place_texture
		mode = tile.place_mode


func _new_light() -> PointLight2D:
	var light: PointLight2D = light_scene.instantiate()
	light.color = tile.light_color
	add_child(light)
	return light


func _edit_tile_at_mouse(layer_index: int, layer_list: Array[TileMap]) -> void:
	if !_is_tile_valid:
		return

	var layer := layer_list[layer_index]
	var tile_id := layer.get_cell_source_id(0, _current_tile)
	var item_id := Items.get_id_from_tile(tile_id)
	var tile_above_id := layer_list[layer_index + 1].get_cell_source_id(0, _current_tile) if layer_index < layer_list.size() - 1 else -2
	match mode:
		Mode.REMOVE:
			if Items.is_soil(item_id) and !Items.is_dirt(item_id):
				layer.set_cell(0, _current_tile, Items.get_item_data(Items.ID.DIRT).tile_id, Vector2i(0, 0))
				
			elif Items.is_path(item_id):
				var atlas_coords := layer.get_cell_atlas_coords(0, _current_tile)
				if selecting_side:
					if atlas_coords == Vector2i(0, 3):
						layer.set_cell(0, _current_tile, Items.get_item_data(item_id).tile_id, Vector2i(0, 1))
					elif atlas_coords == Vector2i(0, 2):
						layer.set_cell(0, _current_tile, Items.get_item_data(Items.ID.DIRT).tile_id, Vector2i(0, 0))
					elif atlas_coords == Vector2i(0, 1):
						if tile_above_id < 0:
							layer.set_cell(0, _current_tile)
							Global.change_inventory_item.call(Items.ID.DIRT, 1)
						else:
							print("cant remove block when there are tiles above it")
							return
				else:
					if atlas_coords == Vector2i(0, 3):
						layer.set_cell(0, _current_tile, Items.get_item_data(item_id).tile_id, Vector2i(0, 2))
					elif atlas_coords == Vector2i(0, 2):
						if tile_above_id < 0:
							layer.set_cell(0, _current_tile)
							Global.change_inventory_item.call(Items.ID.DIRT, 1)
						else:
							print("cant remove block when there are tiles above it")
							return
					elif atlas_coords == Vector2i(0, 1):
						layer.set_cell(0, _current_tile, Items.get_item_data(Items.ID.DIRT).tile_id, Vector2i(0, 0))
						
			elif tile_above_id < 0:
				if Items.is_light(item_id):
					light_tile_to_scene[_current_tile].queue_free()
					light_tile_to_scene.erase(_current_tile)
				elif layer.get_cell_atlas_coords(0, _current_tile) == Vector2i.DOWN * 2 and (Items.is_mushroom(item_id) or Items.is_crafter(item_id)):
					var output := 1
					if Items.get_id_from_tile(layers[layer_index - 1].get_cell_source_id(0, _current_tile)) == Items.ID.GREEN_SOIL:
						output *= 2
					Global.change_inventory_item.call(Items.get_item_data(item_id).item_drop, output)
				layer.set_cell(0, _current_tile)
			else:
				print("cant remove block when there are tiles above it")
				return
					
			Global.change_inventory_item.call(item_id, 1)		
		Mode.SELECT:
			if layer.get_cell_atlas_coords(0, _current_tile) == Vector2i.DOWN * 2 and (Items.is_mushroom(item_id) or Items.is_crafter(item_id)):
				var output := 1
				if Items.get_id_from_tile(layers[layer_index - 1].get_cell_source_id(0, _current_tile)) == Items.ID.GREEN_SOIL:
					output *= 2
				Global.change_inventory_item.call(Items.get_item_data(item_id).item_drop, output)
				layer.set_cell(0, _current_tile, tile_id, Vector2i(0, 0))
			else:
				print("selecting tile")
			# show stats or harvest tile
		Mode.NONE:
			print("currently doing nothing")
		Mode.MUSHROOM_MODIFIER:
			print("modify this shroom!!!")
		Mode.PATH:
			layer.set_cell(0, _current_tile, tile.tile_id, Vector2i(0, path_placement))
			Global.change_inventory_item.call(tile.id, -1)
		_:
			layer.set_cell(0, _current_tile, tile.tile_id, Vector2i(0, 0))
			if Items.is_light(tile.id):
				var light := _new_light()
				light.global_position = _current_tile * _tile_size + Vector2i.UP * layer_index * _tile_size / 2 + Vector2i.ONE * _tile_size / 2 + Vector2i.DOWN * _tile_size / 2
				light_tile_to_scene[_current_tile] = light
				
			Global.change_inventory_item.call(tile.id, -1)
	
	
func _check_for_tiles(layer_list: Array[TileMap], tile_size: int) -> int:
	preview.show_full()
	selecting_side = false
	for i in range(layer_list.size() - 1, -1, -1):
		var layer: TileMap = layer_list[i]
		var tile_pos := layer.local_to_map(layer.get_local_mouse_position())
		var tile_id := layer.get_cell_source_id(0, tile_pos)
		var tile_item_id := Items.get_id_from_tile(tile_id)
		var tile_above_id := layer_list[i + 1].get_cell_source_id(0, tile_pos) if i < layer_list.size() - 1 else -2
		
		var offset_tile_pos := layer.local_to_map(layer.get_local_mouse_position() + Vector2.UP * tile_size / 2)
		var offset_tile_id :=  layer.get_cell_source_id(0, offset_tile_pos)
		var offset_tile_item_id := Items.get_id_from_tile(offset_tile_id)
		var offset_tile_above_id := layer_list[i + 1].get_cell_source_id(0, offset_tile_pos) if i < layer_list.size() - 1 else -2
		
		match mode:
			Mode.MUSHROOM:
				if tile_id != -1 and Items.is_whole(tile_item_id):
					if tile_above_id == -1 and Items.is_soil(tile_item_id):
						_current_tile = tile_pos
						i += 1
					else:
						break
				else:
					continue
			Mode.OTHER_TILE, Mode.DIRT:
				if tile_id != -1 and Items.is_whole(tile_item_id):
					if tile_above_id == -1:
						_current_tile = tile_pos
						i += 1
					else:
						break
				else:
					continue
					
				if Items.is_crafter(tile.id): # This needs to be changed so that the crafters need input and then get added to the array
					crafters_to_progress.append([layers[i], tile_pos])
			Mode.SOIL:
				if tile_id != -1 and Items.is_whole(tile_item_id):
					if Items.is_dirt(tile_item_id) and (tile_above_id < 0 or Items.is_mushroom(Items.get_id_from_tile(tile_above_id))):
						_current_tile = tile_pos
					else:
						break
				elif offset_tile_id != -1 and Items.is_whole(offset_tile_item_id):
					if Items.is_dirt(offset_tile_item_id) and (offset_tile_above_id < 0 or Items.is_mushroom(Items.get_id_from_tile(offset_tile_above_id))):
						_current_tile = offset_tile_pos
					else:
						break
					
				else:
					continue
			Mode.PATH:
				# If we are hovering a dirt and if the tile above is empty or it is not a mushroom or a whole block then place
				if Items.is_dirt(tile_item_id) and (tile_above_id < 0 or !(Items.is_whole(Items.get_id_from_tile(tile_above_id)) or Items.is_mushroom(Items.get_id_from_tile(tile_above_id)))):
					path_placement = 1
					preview.show_top()
					_current_tile = tile_pos
				elif tile_item_id == tile.id:
					if layer.get_cell_atlas_coords(0, tile_pos) == Vector2i(0, 2):
						path_placement = 3
						preview.show_top()
						_current_tile = tile_pos
					else:
						break
				elif Items.is_dirt(offset_tile_item_id) and (offset_tile_above_id < 0 or !Items.is_mushroom(Items.get_id_from_tile(offset_tile_above_id))):
					path_placement = 2
					preview.show_side()
					_current_tile = offset_tile_pos
				elif offset_tile_item_id == tile.id:
					if layer.get_cell_atlas_coords(0, offset_tile_pos) == Vector2i(0, 1):
						path_placement = 3
						preview.show_side()
						_current_tile = offset_tile_pos
					else:
						break				
				else:
					continue
			Mode.MUSHROOM_MODIFIER:
				if Items.is_mushroom(tile_item_id):
					_current_tile = tile_pos
				elif Items.is_mushroom(offset_tile_item_id):
					_current_tile = offset_tile_pos
				else:
					continue
			Mode.SELECT:
				if tile_id != -1:
					_current_tile = tile_pos
				elif offset_tile_id != -1:
					selecting_side = true
					_current_tile = offset_tile_pos
				else:
					continue
			Mode.REMOVE:
				if tile_id != -1:
					if (!Items.is_dirt(tile_item_id) or i > 0) and tile_above_id < 0:
						_current_tile = tile_pos
						if Items.is_path(tile_item_id) and Vector2i(0, 2) != layer.get_cell_atlas_coords(0, _current_tile):
							preview.show_top()
					else:
						continue
				elif offset_tile_id != -1 and (!Items.is_dirt(offset_tile_item_id) or i > 0):
					selecting_side = true
					_current_tile = offset_tile_pos
					if Items.is_path(offset_tile_item_id) and Vector2i(0, 1) != layer.get_cell_atlas_coords(0, _current_tile):
						preview.show_side()
				else:
					continue
			Mode.NONE:
				continue
		var offset := Vector2i.UP * (tile_size / 2 * i)
		_is_tile_valid = true
		preview.global_position = _current_tile * tile_size + offset
		return i
	
	preview.hide()
	_is_tile_valid = false
	return -1
