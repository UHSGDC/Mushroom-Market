extends Control


func _on_button_pressed() -> void:
	Global.day_cycled.emit()


func _on_shovel_pressed() -> void:
	Global.item_selected.emit(-1)
	Global.shovel_selected.emit()
