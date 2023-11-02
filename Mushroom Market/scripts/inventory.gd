class_name Inventory extends HSplitContainer

@export var item_scene: PackedScene

@onready var item_container = $ColorRect/ScrollContainer/ItemContainer

func _ready() -> void:
	Global.change_inventory_item = change_item
	change_item(Items.ID.DIRT, 1)
	change_item(Items.ID.MUSHROOM, 2)
	change_item(Items.ID.COMPOSTER, 3)


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
