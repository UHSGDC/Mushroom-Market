extends Button


var id: Items.ID
var item_data: ItemData
var price: int

func initialize(item: Items.ID) -> void:
	id = item
	item_data = Items.get_item_data(id)
	$Icon.texture = item_data.item_texture
	price = item_data.price
	if price < 0:
		push_warning("Item added to shop with negative price. Please give it a valid price.")
	
