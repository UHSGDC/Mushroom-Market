extends PanelContainer



@onready var shop_button := $VSplitContainer/Buttons/Panel/Shop
@onready var inventory_button := $VSplitContainer/Buttons/Panel2/Inventory
@onready var profile_button := $VSplitContainer/Buttons/Panel3/Profile

@onready var shop_button_panel := $VSplitContainer/Buttons/Panel
@onready var inventory_button_panel := $VSplitContainer/Buttons/Panel2
@onready var profile_button_panel := $VSplitContainer/Buttons/Panel3

@onready var shop_panel := $VSplitContainer/Panels/Shop
@onready var inventory_panel := $VSplitContainer/Panels/Inventory
@onready var profile_panel := $VSplitContainer/Panels/Profile
	

func _ready() -> void:
	shop_button.button_down.connect(_on_shop_pressed)
	inventory_button.button_down.connect(_on_inventory_pressed)
	profile_button.button_down.connect(_on_profile_pressed)
	
	_on_inventory_pressed()


func _on_shop_pressed() -> void:
	shop_button.disabled = true
	inventory_button.disabled = false
	profile_button.disabled = false
	shop_button_panel.selected = true
	inventory_button_panel.selected = false
	profile_button_panel.selected = false
	shop_panel.show()
	inventory_panel.hide()
	profile_panel.hide()


func _on_inventory_pressed() -> void:
	shop_button.disabled = false
	inventory_button.disabled = true
	profile_button.disabled = false
	shop_button_panel.selected = false
	inventory_button_panel.selected = true
	profile_button_panel.selected = false
	shop_panel.hide()
	inventory_panel.show()
	profile_panel.hide()


func _on_profile_pressed() -> void:
	shop_button.disabled = false
	inventory_button.disabled = false
	profile_button.disabled = true
	shop_button_panel.selected = false
	inventory_button_panel.selected = false
	profile_button_panel.selected = true
	shop_panel.hide()
	inventory_panel.hide()
	profile_panel.show()

