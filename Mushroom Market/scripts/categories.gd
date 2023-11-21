extends GridContainer

signal category_changed(category: Shop.Category)


func _ready() -> void:
	for child in get_children():
		child.button_down.connect(_on_button_down.bind(child))
	_on_button_down.call_deferred($All)
	
	
func _on_button_down(button: Button) ->  void:
	for child in get_children():
		child.disabled = false
		
	button.disabled = true
	
	category_changed.emit(Shop.Category.ALL if button.name == "All" else Shop.Category.MUSHROOMS if button.name == "Mushrooms" else Shop.Category.CRAFTERS if button.name == "Crafters" else Shop.Category.NATURAL if button.name == "Naturals" else Shop.Category.LIGHTS if button.name == "Lights" else Shop.Category.OTHER)
