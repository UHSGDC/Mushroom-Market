extends Node2D
class_name TileManager

@export var layers: Array[TileMap]

var tile: ItemData = null
var _layer_index: int
var _current_tile: Vector2i

@onready var _layers_reversed: Array[TileMap] = layers.duplicate()
@onready var _tile_size: int = layers[0].tile_set.tile_size.x


func _ready() -> void:
	_layers_reversed.reverse()
	Global.item_selected.connect(_on_item_selected)


func _process(delta: float) -> void:
	_layer_index = _check_for_tiles(_layers_reversed.duplicate(), _tile_size)
	if Input.is_action_just_pressed("place"):
		place_tile_at_mouse(_layer_index, layers.duplicate())
	elif Input.is_action_just_pressed("remove"):
		delete_tile_at_mouse(_layer_index, layers.duplicate())


func _on_item_selected(item: Items.ID) -> void:
	tile = Items.get_item_data(item)
	$Preview.texture = tile.place_texture if tile != null else null


func place_tile_at_mouse(layer_index: int, layer_list: Array[TileMap]) -> void:
	var layer := layer_list[layer_index]
	if layer.get_cell_source_id(0, _current_tile) == -1:
		layer.set_cell(0, _current_tile, 3, Vector2i(0, 0))
		return
	
	if layer_index + 1 >= layer_list.size():
		return
	var layer_above := layer_list[layer_index + 1]
	layer_above.set_cell(0, _current_tile, 3, Vector2i(0, 0))
	
	
func delete_tile_at_mouse(layer_index: int, layer_list: Array[TileMap]) -> void:
	var layer := layer_list[layer_index]
	
	layer.set_cell(0, _current_tile, -1)


func _check_for_tiles(layer_list: Array[TileMap], tile_size: int) -> int:
	for i in layer_list.size():
		var layer: TileMap = layer_list[i]
		
		var tile_pos := layer.local_to_map(layer.get_local_mouse_position())
		var offset_tile_pos := layer.local_to_map(layer.get_local_mouse_position() + Vector2.UP * tile_size / 2)
		if layer.get_cell_source_id(0, tile_pos) != -1:
			_current_tile = tile_pos
		elif layer.get_cell_source_id(0, offset_tile_pos) != -1:
			_current_tile = offset_tile_pos
		elif i == layer_list.size() - 1:
			_current_tile = tile_pos
		else:
			continue
		
		var offset := Vector2i.UP * (tile_size / 2 * (layer_list.size() - i - 1))
		$Preview.global_position = _current_tile * tile_size + offset
		return layer_list.size() - 1 - i
	
	return 0
