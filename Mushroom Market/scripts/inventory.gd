class_name Inventory extends Container

@export var item_scene: PackedScene

@onready var item_container = $PanelContainer/ScrollContainer/ItemContainer

func _ready() -> void:
	Global.change_inventory_item = change_item
	$Categories.category_changed.connect(_on_category_changed)
	for value in Items.ID.values():
		if value == Items.ID.NO_ITEM:
			continue
		change_item(value, 1)


func change_item(id: Items.ID, count: int) -> void:
	for item in item_container.get_children():
		if id == item.id:
			item.count += count
			return
			
	_new_item(id, count)


func _new_item(id: Items.ID, count: int) -> void:
	var item: InventoryItem = item_scene.instantiate()
	item_container.add_child(item)
	item.initialize(id, count)
	
	
func _on_category_changed(filter: Shop.Category) -> void:
	match filter:
		Shop.Category.ALL:
			for child in item_container.get_children():
				child.show()
		Shop.Category.MUSHROOMS:
			for child in item_container.get_children():
				if Items.is_mushroom(child.id):
					child.show()
				else:
					child.hide()
		Shop.Category.CRAFTERS:
			for child in item_container.get_children():
				if Items.is_crafter(child.id):
					child.show()
				else:
					child.hide()
		Shop.Category.NATURAL:
			for child in item_container.get_children():
				if Items.is_natural(child.id):
					child.show()
				else:
					child.hide()
		Shop.Category.LIGHTS:
			for child in item_container.get_children():
				if Items.is_light(child.id):
					child.show()
				else:
					child.hide()
		Shop.Category.OTHER:
			for child in item_container.get_children():
				if Items.is_misc(child.id):
					child.show()
				else:
					child.hide()
			
		
			
		

func _on_shovel_pressed() -> void:
	Global.item_selected.emit(Items.ID.NO_ITEM)
	Global.shovel_selected.emit()
