extends GridContainer

signal filter_changed(filter: Inventory.Filter)


func _ready() -> void:
	for child in get_children():
		child.pressed.connect(_on_button_pressed.bind(child))
	_on_button_pressed.call_deferred($All)
	
	
func _on_button_pressed(button: Button) ->  void:
	for child in get_children():
		child.disabled = false
		
	button.disabled = true
	
	filter_changed.emit(Inventory.Filter.PLACEABLES if button.name == "Placeables" else Inventory.Filter.SELLABLES if button.name == "Sellables" else Inventory.Filter.OTHER if button.name == "Other" else Inventory.Filter.ALL)
	
	
	
	
