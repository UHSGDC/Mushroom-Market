class_name ItemData extends Resource

@export var name: String
@export var id: Items.ID
@export var use_tags: Array[Items.Use]
@export var place_mode: TileManager.Mode
@export var tile_id: int = -1
@export var raw_texture: Texture : set = _set_raw_texture
@export var price: int = -1

var item_texture: AtlasTexture = AtlasTexture.new()
var place_texture: AtlasTexture = AtlasTexture.new()


func _set_raw_texture(value: Texture) -> void:
	raw_texture = value
	place_texture.atlas = value
	place_texture.region = Rect2(0, 0, 8, 12)
	item_texture = place_texture.duplicate()

	
