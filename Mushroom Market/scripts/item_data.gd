extends Resource

class_name ItemData

@export var name: String
@export var id: Items.ID
@export var use_mode: Items.Use
@export var raw_texture: Texture : set = _set_raw_texture
		
var item_texture: AtlasTexture = AtlasTexture.new()
var place_texture: AtlasTexture = AtlasTexture.new()

@export var tile_id: int


func _set_raw_texture(value: Texture) -> void:
	raw_texture = value
	place_texture.atlas = value
	place_texture.region = Rect2(0, 0, 8, 12)
	item_texture = place_texture.duplicate()

	
