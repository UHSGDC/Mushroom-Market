class_name BuyButton extends Button


var product: Items.ID = Items.ID.NO_ITEM
var price: int = -1
@onready var product_icon := $HBoxContainer/Icon
@onready var price_label := $HBoxContainer/Price


func _ready() -> void:
	hide()
	Player.money_changed.connect(_on_money_changed)


func select(product: Items.ID):
	visible = product != Items.ID.NO_ITEM
	if !visible:
		return
		
	var item_data := Items.get_item_data(product)
	price = item_data.price
	self.product = product
	
	product_icon.texture = item_data.item_texture
	price_label.text = "x " + str(price)

	disabled = !Player.has_funds(price)


func _on_money_changed(money: int) -> void:
	disabled = !Player.has_funds(price)


func _on_pressed() -> void:
	if Player.has_funds(price):
		Global.change_inventory_item.call(product, 1)
		Player.money -= price
