class_name ProductData extends ItemData


func _set_raw_texture(value: Texture) -> void:
	super(value)
	item_texture.region.position.y += 24
