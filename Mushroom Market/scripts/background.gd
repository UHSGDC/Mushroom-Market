extends Sprite2D

func _ready() -> void:
	var tween := create_tween()
	tween.set_loops()
	tween.tween_property(self, "position", Vector2(0, 0), 100)
	tween.tween_property(self, "position", Vector2(-10000, 0), 0)
