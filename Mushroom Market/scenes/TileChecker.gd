extends Node2D
class_name TileChecker

@export var layers: Array[TileMap]

var _layer_index: int
var _current_tile: Vector2i

@onready var _layers_reversed: Array[TileMap] = layers.duplicate()
@onready var _tile_size: int = layers[0].tile_set.tile_size.x


func _ready() -> void:
	_layers_reversed.reverse()


func _process(delta: float) -> void:
	_layer_index = _check_for_tiles(_layers_reversed.duplicate(), _tile_size)
	if Input.is_action_just_pressed("place"):
		place_tile_at_mouse(_layer_index, layers.duplicate())
	elif Input.is_action_just_pressed("remove"):
		delete_tile_at_mouse(_layer_index, layers.duplicate())
	

func place_tile_at_mouse(index: int, layer_list: Array[TileMap]) -> void:
	var layer := layer_list[index]
	if index + 1 >= layer_list.size():
		return
	var layer_above := layer_list[index + 1]
	var tile_pos := layer.local_to_map(layer.get_local_mouse_position())
	
	layer_above.set_cell(0, tile_pos, 3, Vector2i(0, 0))
	
	
func delete_tile_at_mouse(index: int, layer_list: Array[TileMap]) -> void:
	var layer := layer_list[index]
	var tile_pos := layer.local_to_map(layer.get_local_mouse_position())
	
	layer.set_cell(0, tile_pos, -1)


func _check_for_tiles(layer_list: Array[TileMap], tile_size: int) -> int:
	for i in layer_list.size():
		var layer: TileMap = layer_list[i]
		var tile_pos := layer.local_to_map(layer.get_local_mouse_position())
		if layer.get_cell_source_id(0, tile_pos) != -1:
			var offset := Vector2i.UP * (tile_size / 2 * (layer_list.size() - 1 - i))
			$Polygon2D.global_position = tile_pos * tile_size + offset
			return layer_list.size() - 1 - i
	
	# add selection for blank tiles here
	return -1
