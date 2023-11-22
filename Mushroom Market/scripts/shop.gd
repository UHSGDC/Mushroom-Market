class_name Shop extends VBoxContainer

enum Category {
	ALL,
	MUSHROOMS,
	CRAFTERS,
	NATURAL,
	LIGHTS,
	OTHER
}

@export var product_scene: PackedScene

var levels: Array = [
	[Items.ID.DIRT, Items.ID.PURPLE_MUSHROOM_SEED],
	[Items.ID.STONE_PATH],
	[Items.ID.RED_SOIL]
]

@onready var product_container := $PanelContainer/ScrollContainer/ProductContainer


func _ready() -> void:
	Player.level_changed.connect(_on_level_changed)


func _on_level_changed(level: int) -> void:
	for product in levels[level]:
		_new_product(product)


func _new_product(id: Items.ID) -> void:
	var product = product_scene.instantiate()
	product_container.add_child(product)
	product.initialize(id)


func _on_category_changed(category: Category) -> void:

	match Category:
		Category.ALL:
			for child in product_container.get_children():
				child.show()
		Category.MUSHROOMS:
			for child in product_container.get_children():
				var product_data: ItemData = child.product_data
		Category.CRAFTERS:
			for child in product_container.get_children():
				var product_data: ItemData = child.product_data
		Category.NATURAL:
			for child in product_container.get_children():
				var product_data: ItemData = child.product_data
		Category.LIGHTS:
			for child in product_container.get_children():
				var product_data: ItemData = child.product_data
		Category.OTHER:
			for child in product_container.get_children():
				var product_data: ItemData = child.product_data
