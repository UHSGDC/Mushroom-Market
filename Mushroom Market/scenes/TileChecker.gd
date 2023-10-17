extends Node2D


var in_layer1: bool = false
var in_layer2: bool = false
var in_layer3: bool = false
@onready var layer1 := $"../Layer1"
@onready var layer2 := $"../Layer2"
@onready var layer3 := $"../Layer3"


func _process(delta: float) -> void:
	in_layer1 = layer1.get_cell_source_id(0, layer1.local_to_map(layer1.get_local_mouse_position())) != -1
	in_layer2 = layer2.get_cell_source_id(0, layer2.local_to_map(layer2.get_local_mouse_position())) != -1
	in_layer3 = layer3.get_cell_source_id(0, layer3.local_to_map(layer3.get_local_mouse_position())) != -1
	
	if in_layer3:
		$Polygon2D.global_position = layer3.local_to_map(layer3.get_local_mouse_position()) * 12  + Vector2i.DOWN * 24
	elif in_layer2:
		$Polygon2D.global_position = layer2.local_to_map(layer2.get_local_mouse_position()) * 12 + Vector2i.DOWN * 18
	elif in_layer1:
		$Polygon2D.global_position = layer1.local_to_map(layer1.get_local_mouse_position()) * 12 + Vector2i.DOWN * 12
