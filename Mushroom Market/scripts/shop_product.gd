class_name ShopProduct extends Button


var id: Items.ID
var item_data: ItemData
var selected: bool = false :
	set(value):
		selected = value
		$Selected.visible = selected


func initialize(item: Items.ID) -> void:
	id = item
	item_data = Items.get_item_data(id)
	$Icon.texture = item_data.item_texture
	
