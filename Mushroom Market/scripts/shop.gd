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
	[Items.ID.DIRT, Items.ID.PURPLE_SHROOM_SEED],
	[Items.ID.STONE_PATH, Items.ID.BLUE_LAMP],
	[Items.ID.RED_SOIL]
]

var selected_product: Items.ID = Items.ID.NO_ITEM : 
	set(value):
		selected_product = value
		buy_button.select(selected_product)


@onready var product_container := $PanelContainer/ScrollContainer/ProductContainer
@onready var buy_button: BuyButton = $BuyButton


func _ready() -> void:
	Player.level_changed.connect(_on_level_changed)
	$Categories.category_changed.connect(_on_category_changed)


func _on_level_changed(level: int) -> void:
	for item in levels[level]:
		_new_product(item)


func _new_product(id: Items.ID) -> void:
	var product: Button = product_scene.instantiate()
	product_container.add_child(product)
	product.initialize(id)
	product.button_down.connect(_on_product_selected.bind(product))


func _on_product_selected(product: ShopProduct) ->  void:
	var product_selected := !product.selected
	for child in product_container.get_children():
		child.selected = false
		
	product.selected = product_selected
	
	selected_product = product.id
	if !product_selected:
		selected_product = Items.ID.NO_ITEM
	

func _on_category_changed(category: Category) -> void:
	match category:
		Category.ALL:
			for child in product_container.get_children():
				child.show()
		Category.MUSHROOMS:
			for child in product_container.get_children():
				if Items.is_mushroom(child.id):
					child.show()
				else:
					child.hide()
		Category.CRAFTERS:
			for child in product_container.get_children():
				if Items.is_crafter(child.id):
					child.show()
				else:
					child.hide()
		Category.NATURAL:
			for child in product_container.get_children():
				if Items.is_natural(child.id):
					child.show()
				else:
					child.hide()
		Category.LIGHTS:
			for child in product_container.get_children():
				if Items.is_light(child.id):
					child.show()
				else:
					child.hide()
		Category.OTHER:
			for child in product_container.get_children():
				if Items.is_misc(child.id):
					child.show()
				else:
					child.hide()
