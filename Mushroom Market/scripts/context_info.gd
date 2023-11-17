extends Label

func _ready() -> void:
	Global.item_selected.connect(
		func(item: Items.ID):
			var item_data := Items.get_item_data(item)
			text = item_data.name + " selected" if item_data else ""
	)
