class_name Shop extends VBoxContainer

enum Category {
	ALL,
	MUSHROOMS,
	CRAFTERS,
	NATURAL,
	LIGHTS,
	OTHER
}

@onready var product_container := $PanelContainer/ScrollContainer/ProductContainer


func _on_category_changed(category: Category) -> void:

	match Category:
		Category.ALL:
			for child in product_container.get_children():
				child.show()
		Category.MUSHROOMS:
			for child in product_container.get_children():
				var item_data: ItemData = child.item_data
		Category.CRAFTERS:
			for child in product_container.get_children():
				var item_data: ItemData = child.item_data
		Category.NATURAL:
			for child in product_container.get_children():
				var item_data: ItemData = child.item_data
		Category.LIGHTS:
			for child in product_container.get_children():
				var item_data: ItemData = child.item_data
		Category.OTHER:
			for child in product_container.get_children():
				var item_data: ItemData = child.item_data
