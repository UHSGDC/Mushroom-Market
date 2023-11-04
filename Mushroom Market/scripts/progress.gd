extends Control


func _on_button_pressed() -> void:
	Global.day_cycled.emit()
