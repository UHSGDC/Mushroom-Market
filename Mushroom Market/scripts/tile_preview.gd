extends Sprite2D

var layer_index: int : 
	set(value):
		layer_index = value
		z_index = value - 1
		$TopPreview.z_index = value
		
var mode: TileManager.Mode :
	set(value):
		mode = value
		$TopPreview/Top.show()
		match value:
			TileManager.Mode.MUSHROOM, TileManager.Mode.OTHER_TILE, TileManager.Mode.DIRT:
				$TopPreview/Top.hide()
				
@onready var flash_tween: Tween = create_tween()


func _ready() -> void:
	flash_tween_preview(flash_tween)


func _on_texture_changed() -> void:
	$TopPreview.texture = texture


func flash_tween_preview(tween: Tween) -> void:
	tween.set_loops()
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 0.5), 0.8)
	tween.parallel().tween_property($TopPreview, "modulate", Color(1, 1, 1, 0.5), 0.8)
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 1), 0.8)
	tween.parallel().tween_property($TopPreview, "modulate", Color(1, 1, 1, 1), 0.8)
	



