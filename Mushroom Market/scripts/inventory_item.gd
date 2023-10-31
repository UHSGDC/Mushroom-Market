extends PanelContainer
class_name InventoryItem

var count: int = 0:
	set(value):
		count = value
		$Count.text = "x" + str(value)
		visible = count > 0

var id: Items.ID
var item_data: ItemData

var hovering: bool = false


func _ready() -> void:
	Global.item_selected.connect(_on_item_selected)


func _input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed and hovering
	):
		$Selected.visible = !$Selected.visible
		if $Selected.visible:
			Global.item_selected.emit(id)
		else:
			Global.item_selected.emit(-1)


func _on_mouse_entered() -> void:
	hovering = true
	$Hovered.show()


func _on_mouse_exited() -> void:
	hovering = false
	$Hovered.hide()


func _on_item_selected(item: Items.ID) -> void:
	if id != item:
		$Selected.hide()


func initiliaze(item: Items.ID, _count: int) -> void:
	id = item
	item_data = Items.get_item_data(item)
	$Icon.texture = item_data.item_texture
	count = _count


