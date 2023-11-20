class_name Inventory extends Container

enum Filter {
	ALL,
	SELLABLES,
	PLACEABLES,
	OTHER
}

@export var item_scene: PackedScene

@onready var item_container = $PanelContainer/ScrollContainer/ItemContainer

func _ready() -> void:
	Global.change_inventory_item = change_item
	$Filters.filter_changed.connect(_on_filter_changed)
	change_item(Items.ID.STONE_PATH, 10)
	change_item(Items.ID.RED_SOIL, 10)
	change_item(Items.ID.PURPLE_MUSHROOM_SEED, 2)
	change_item(Items.ID.CAULDRON, 3)
	change_item(Items.ID.COMPOSTER, 1)
	change_item(Items.ID.BLUE_LAMP, 10)
	change_item(Items.ID.PURPLE_MUSHROOM, 10)
	change_item(Items.ID.DIRT, 10)


func change_item(id: Items.ID, count: int) -> void:
	for item in item_container.get_children():
		if id == item.id:
			item.count += count
			return
			
	_new_item(id, count)


func _new_item(id: Items.ID, count: int) -> void:
	var item: InventoryItem = item_scene.instantiate()
	item_container.add_child(item)
	item.initiliaze(id, count)
	
	
func _on_filter_changed(filter: Filter) -> void:
	match filter:
		Filter.ALL:
			for child in item_container.get_children():
				child.show()
		Filter.SELLABLES:
			for child in item_container.get_children():
				var item_data: ItemData = child.item_data
				if item_data.use_tags.has(Items.Use.TRADEABLE):
					child.show()
				else:
					child.hide()
		Filter.PLACEABLES:
			for child in item_container.get_children():
				var item_data: ItemData = child.item_data
				if item_data.use_tags.has(Items.Use.TILEMAP):
					child.show()
				else:
					child.hide()
		Filter.OTHER:
			for child in item_container.get_children():
				var item_data: ItemData = child.item_data
				if item_data.use_tags.has(Items.Use.OTHER):
					child.show()
				else:
					child.hide()
		

func _on_shovel_pressed() -> void:
	Global.shovel_selected.emit()
