extends HSplitContainer
class_name Inventory

@export var ITEM_SCENE: PackedScene

@onready var ITEM_CONTAINER = $ColorRect/ScrollContainer/ItemContainer

func _ready() -> void:
	add_items(Items.ID.DIRT, 1)
	add_items(Items.ID.MUSHROOM, 2)
	add_items(Items.ID.COMPOSTER, 3)


func add_items(id: Items.ID, count: int) -> void:
	for item in ITEM_CONTAINER.get_children():
		if id == item.id:
			item.count += count
			return
			
	_new_item(id, count)


func _new_item(id: Items.ID, count: int) -> void:
	var item: InventoryItem = ITEM_SCENE.instantiate()
	ITEM_CONTAINER.add_child(item)
	item.initiliaze(id, count)
