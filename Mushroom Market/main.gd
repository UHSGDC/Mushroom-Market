extends Node

@onready var garden := $World/SubViewport/Garden
@onready var market := $World/SubViewport/Market


func _on_menus_switch_pressed() -> void:
	market.visible = garden.visible
	garden.visible = !garden.visible
	
	if garden.visible:
		garden.process_mode = Node.PROCESS_MODE_INHERIT
		market.process_mode = Node.PROCESS_MODE_DISABLED
		Player.day += 1
	else:
		market.process_mode = Node.PROCESS_MODE_INHERIT
		garden.process_mode = Node.PROCESS_MODE_DISABLED
