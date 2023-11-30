extends Node

@onready var garden := $World/SubViewport/Garden
@onready var market := $World/SubViewport/Market


func _on_menus_switch_pressed() -> void:
	Player.day += 1


func _on_button_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_volume_db(0, int(button_pressed) * 80 - 80)
