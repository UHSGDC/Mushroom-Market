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
		
var _layer_index: int
var _current_tile: Vector2i
var _is_tile_valid: bool = false

var mode: Mode = Mode.SELECT

@onready var _tile_size: int = layers[0].tile_set.tile_size.x



func _ready() -> void:
	print(layers.size())
	Global.item_selected.connect(_on_item_selected)


func _process(delta: float) -> void:
	_layer_index = _check_for_tiles(layers.duplicate(), _tile_size)
	if Input.is_action_just_pressed("change_tile"):
		edit_tile_at_mouse(_layer_index, layers.duplicate())


func _on_item_selected(item: Items.ID) -> void:
	tile = Items.get_item_data(item)
	if !tile:
		mode = Mode.SELECT
		return
	$Preview.texture = tile.place_texture
	if tile.use_tags.has(Items.Use.TILEMAP):
		mode = tile.place_mode
	else:
		mode = Mode.NONE


func edit_tile_at_mouse(layer_index: int, layer_list: Array[TileMap]) -> void:
	print("this needs to be implemeented again")


#func edit_tile_at_mouse(layer_index: int, layer_list: Array[TileMap]) -> void:
#	var layer := layer_list[layer_index]
#	if layer.get_cell_source_id(0, _current_tile) == -1:
#		layer.set_cell(0, _current_tile, 3, Vector2i(0, 0))
#		return
#
#	if layer_index + 1 >= layer_list.size():
#		return
#	var layer_above := layer_list[layer_index + 1]
#	layer_above.set_cell(0, _current_tile, 3, Vector2i(0, 0))
	
	
func delete_tile_at_mouse(layer_index: int, layer_list: Array[TileMap]) -> void:
	var layer := layer_list[layer_index]
	
	layer.set_cell(0, _current_tile, -1)
	
	
func _check_for_tiles(layer_list: Array[TileMap], tile_size: int) -> int:
	for i in range(layer_list.size() - 1, -1, -1):
		var layer: TileMap = layer_list[i]
		var tile_pos := layer.local_to_map(layer.get_local_mouse_position())
		var tile_id := layer.get_cell_source_id(0, tile_pos)
		var tile_item_id: Items.ID = Items.get_id_from_tile(tile_id)
		var tile_above_id := layer_list[i + 1].get_cell_source_id(0, tile_pos) if i < layer_list.size() - 1 else -1
		match mode:
			Mode.MUSHROOM:
				if tile_id != -1 and tile_above_id == -1 and Items.is_soil(tile_item_id):
					_current_tile = tile_pos
					$Preview.show()
					i += 1
					print("open!!!")
				else:
					$Preview.hide()
					continue

			Mode.OTHER_TILE:
				if tile_id != -1 and tile_above_id == -1 and Items.is_whole(tile_item_id):
					_current_tile = tile_pos
					$Preview.show()
					i += 1
					print("open!!!")
				else:
					$Preview.hide()
					continue
			Mode.DIRT:
				if tile_id != -1 and tile_above_id == -1:
					_current_tile = tile_pos
					$Preview.show()
					i += 1
					print("open!!!")
				else:
					$Preview.hide()
					continue
			Mode.SOIL:
				pass
			Mode.PATH:
				pass
			Mode.MUSHROOM_MODIFIER:
				pass
			Mode.SELECT:
				pass
			Mode.REMOVE:
				pass
			Mode.NONE:
				print("mode is none lmao lol rofl xD")
		var offset := Vector2i.UP * (tile_size / 2 * i)
		$Preview.global_position = _current_tile * tile_size + offset
		return i

	print("invalid")
	return 0


#func _check_for_tiles(layer_list: Array[TileMap], tile_size: int) -> int:
#	for i in range(layer_list.size() - 1, -1, -1): # need to make match statements z... z.. for each mode z.. z.. z... ... 
#		var layer: TileMap = layer_list[i]
#
#		var tile_pos := layer.local_to_map(layer.get_local_mouse_position())
#		if layer.get_cell_source_id(0, tile_pos) != -1:
#			_current_tile = tile_pos
#		elif i == 0:
#			_current_tile = tile_pos
#		else:
#			continue
#
#		var offset := Vector2i.UP * (tile_size / 2 * i)
#		$Preview.global_position = _current_tile * tile_size + offset
#		return i
#
#	return 0
