extends Sprite2D

var mode: TileManager.Mode :
	set(value):
		mode = value
		$Top.show()
		match value:
			TileManager.Mode.MUSHROOM, TileManager.Mode.OTHER_TILE, TileManager.Mode.DIRT:
				$Top.hide()
				
@onready var flash_tween: Tween = create_tween()


func _ready() -> void:
	flash_tween_preview(flash_tween)
	

func flash_tween_preview(tween: Tween) -> void:
	tween.set_loops()
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 0.5), 0.8)
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 1), 0.8)
	
