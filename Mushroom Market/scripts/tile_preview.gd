extends Sprite2D


const MIN_ALPHA = 0.3

var _layer_index: int
		
var mode: TileManager.Mode :
	set(value):
		mode = value
		removing = false
		show_outline()
		match value:
			TileManager.Mode.MUSHROOM, TileManager.Mode.OTHER_TILE, TileManager.Mode.DIRT:
				hide_outline()
			TileManager.Mode.REMOVE:
				removing = true
				
var removing: bool :
	set(value):
		removing = value
		if value:
			side_outline.modulate = Color(1, 1, 1, 0.4)
			top_outline.modulate = Color(1, 1, 1, 0.4)
		else:
			side_outline.modulate = Color(0, 0, 0, 0.4)
			top_outline.modulate = Color(0, 0, 0, 0.4)
				
@onready var flash_tween: Tween = create_tween()
@onready var top_preview: Sprite2D = %TopPreview
@onready var top_outline: Polygon2D = top_preview.get_node("Top")
@onready var side_outline: Polygon2D = $Side


func _ready() -> void:
	removing = false
	show_full()
	flash_tween_preview(flash_tween)


func _on_texture_changed() -> void:
	top_preview.texture = texture
	
	
func _process(delta: float) -> void:
	top_preview.position = self.position
	

func set_layer_index(value: int, elevate_side: bool):
	_layer_index = value
	z_index = value - 1 + int(elevate_side)
	top_preview.z_index = value


func show_side() -> void:
	show()
	top_preview.hide()
	
	
func show_full() -> void:
	show()
	top_preview.show()
	

func show_top() -> void:
	hide()
	top_preview.show()
	
	
func show_outline() -> void:
	top_outline.show()
	side_outline.show()
	
	
func hide_outline() -> void:
	top_outline.hide()
	side_outline.hide()


func flash_tween_preview(tween: Tween) -> void:
	tween.set_loops()
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, MIN_ALPHA), 0.8)
	tween.parallel().tween_property(top_preview, "self_modulate", Color(1, 1, 1, MIN_ALPHA), 0.8)
	tween.parallel().tween_property(top_outline, "self_modulate", Color(1, 0, 0, MIN_ALPHA), 0.8)
	tween.parallel().tween_property(side_outline, "self_modulate", Color(1, 0, 0, MIN_ALPHA), 0.8)
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 1), 0.8)
	tween.parallel().tween_property(top_preview, "self_modulate", Color(1, 1, 1, 1), 0.8)
	tween.parallel().tween_property(top_outline, "self_modulate", Color(1, 0, 0, 1), 0.8)
	tween.parallel().tween_property(side_outline, "self_modulate", Color(1, 0, 0, 1), 0.8)
